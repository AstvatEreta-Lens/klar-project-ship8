//
//  WebhookService.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 14/11/25.
//


import Foundation
import Network

// MARK: - Local Webhook Server
class WebhookService {
    private var listener: NWListener?
    private var port: UInt16 = 8080
    
    var onMessageReceived: ((WebhookMessageData) -> Void)?
    var onStatusUpdate: ((StatusUpdateData) -> Void)?
    
    func start(port: UInt16 = 8080) throws {
        self.port = port
        let parameters = NWParameters.tcp
        parameters.allowLocalEndpointReuse = true
        
        print("\n🌐 [WEBHOOK] Initializing webhook server...")
        print("🌐 [WEBHOOK] Port: \(port)")
        
        listener = try NWListener(using: parameters, on: NWEndpoint.Port(integerLiteral: port))
        
        listener?.newConnectionHandler = { [weak self] connection in
            print("🌐 [WEBHOOK] New connection received")
            self?.handleConnection(connection)
        }
        
        listener?.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("✅ [WEBHOOK] Local webhook server started successfully on port \(self.port)")
            case .failed(let error):
                print("❌ [WEBHOOK] Server failed: \(error)")
            case .cancelled:
                print("🛑 [WEBHOOK] Server cancelled")
            default:
                break
            }
        }
        
        listener?.start(queue: .global(qos: .userInitiated))
        print("🌐 [WEBHOOK] Server listener started\n")
    }
    
    func stop() {
        print("\n🛑 [WEBHOOK] Stopping webhook server...")
        listener?.cancel()
        listener = nil
        print("✅ [WEBHOOK] Webhook server stopped\n")
    }
    
    private func handleConnection(_ connection: NWConnection) {
        connection.start(queue: .global())
        receiveData(from: connection)
    }
    
    private func receiveData(from connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { [weak self] data, _, isComplete, error in
            
            if let data = data, !data.isEmpty {
                self?.processRequest(data: data, connection: connection)
            }
            
            if isComplete {
                connection.cancel()
            } else if error == nil {
                self?.receiveData(from: connection)
            }
        }
    }
    
    private func processRequest(data: Data, connection: NWConnection) {
        print("\n🌐 [WEBHOOK] Processing HTTP request...")
        print("🌐 [WEBHOOK] Request size: \(data.count) bytes")
        
        guard let requestString = String(data: data, encoding: .utf8) else {
            print("❌ [WEBHOOK] Failed to decode request as UTF-8")
            sendResponse(connection: connection, statusCode: 400, body: "Bad Request")
            return
        }
        
        // Parse HTTP request
        let lines = requestString.components(separatedBy: "\r\n")
        guard let firstLine = lines.first else {
            print("❌ [WEBHOOK] Empty request line")
            sendResponse(connection: connection, statusCode: 400, body: "Bad Request")
            return
        }
        
        print("🌐 [WEBHOOK] Request line: \(firstLine)")
        
        // Accept POST /webhook endpoint (backend sends to /webhook)
        guard firstLine.contains("POST /webhook") || firstLine.contains("POST /") else {
            print("⚠️ Invalid endpoint: \(firstLine)")
            sendResponse(connection: connection, statusCode: 404, body: "Not Found")
            return
        }
        
        // Find header-body separator
        guard let headerEndRange = requestString.range(of: "\r\n\r\n") else {
            print("❌ No body separator found")
            sendResponse(connection: connection, statusCode: 400, body: "Bad Request")
            return
        }
        
        // Extract headers
        let headerString = String(requestString[..<headerEndRange.lowerBound])
        let headers = parseHeaders(headerString)
        
        // Extract body
        let bodyStartIndex = headerEndRange.upperBound
        let bodyString = String(requestString[bodyStartIndex...])
        
        // Check Content-Length if present
        var bodyData: Data
        if let contentLengthStr = headers["Content-Length"],
           let contentLength = Int(contentLengthStr),
           contentLength > 0 {
            // Use specified length
            let bodyStringPrefix = String(bodyString.prefix(contentLength))
            guard let data = bodyStringPrefix.data(using: .utf8) else {
                sendResponse(connection: connection, statusCode: 400, body: "Bad Request")
                return
            }
            bodyData = data
        } else {
            // Use entire remaining string
            guard let data = bodyString.data(using: .utf8) else {
                sendResponse(connection: connection, statusCode: 400, body: "Bad Request")
                return
            }
            bodyData = data
        }
        
        print("📦 Body length: \(bodyData.count) bytes")
        
        // Parse JSON payload
        do {
            let decoder = JSONDecoder()
            let webhook = try decoder.decode(WebhookPayload.self, from: bodyData)
            
            print("✅ [WEBHOOK] Webhook payload parsed successfully")
            print("✅ [WEBHOOK] Type: \(webhook.type)")
            print("✅ [WEBHOOK] Timestamp: \(webhook.timestamp)")
            
            DispatchQueue.main.async { [weak self] in
                switch webhook.data {
                case .message(let messageData):
                    print("📨 [WEBHOOK] Triggering message callback with data")
                    self?.onMessageReceived?(messageData)
                    
                case .status(let statusData):
                    print("📊 [WEBHOOK] Triggering status callback with data")
                    self?.onStatusUpdate?(statusData)
                }
            }
            
            sendResponse(connection: connection, statusCode: 200, body: "OK")
            print("✅ [WEBHOOK] Response sent: 200 OK\n")
        } catch {
            print("❌ [WEBHOOK] Error parsing webhook payload: \(error)")
            print("❌ [WEBHOOK] Error type: \(type(of: error))")
            if let bodyString = String(data: bodyData, encoding: .utf8) {
                print("📄 [WEBHOOK] Raw body (first 500 chars): \(bodyString.prefix(500))")
            }
            sendResponse(connection: connection, statusCode: 400, body: "Bad Request: \(error.localizedDescription)")
            print("❌ [WEBHOOK] Response sent: 400 Bad Request\n")
        }
    }
    
    private func parseHeaders(_ headerString: String) -> [String: String] {
        var headers: [String: String] = [:]
        let lines = headerString.components(separatedBy: "\r\n")
        
        for line in lines {
            if let colonIndex = line.firstIndex(of: ":") {
                let key = String(line[..<colonIndex]).trimmingCharacters(in: .whitespaces)
                let value = String(line[line.index(after: colonIndex)...]).trimmingCharacters(in: .whitespaces)
                headers[key] = value
            }
        }
        
        return headers
    }
    
    private func sendResponse(connection: NWConnection, statusCode: Int, body: String) {
        let response = """
        HTTP/1.1 \(statusCode) OK\r
        Content-Type: text/plain\r
        Content-Length: \(body.utf8.count)\r
        Connection: close\r
        \r
        \(body)
        """
        
        if let responseData = response.data(using: .utf8) {
            connection.send(content: responseData, completion: .contentProcessed { _ in
                connection.cancel()
            })
        }
    }
}
