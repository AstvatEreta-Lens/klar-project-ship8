//
//  WebhookService.swift
//  KlarProject
//
//  Created by Ahmad Al Wabil on 06/11/25.
//


import Foundation
import Network

// MARK: - Local Webhook Server
class WebhookService {
    private var listener: NWListener?
    private let port: UInt16 = 8080
    
    var onMessageReceived: ((WebhookMessageData) -> Void)?
    var onStatusUpdate: ((StatusUpdateData) -> Void)?
    
    func start() throws {
        let parameters = NWParameters.tcp
        parameters.allowLocalEndpointReuse = true
        
        listener = try NWListener(using: parameters, on: NWEndpoint.Port(integerLiteral: port))
        
        listener?.newConnectionHandler = { [weak self] connection in
            self?.handleConnection(connection)
        }
        
        listener?.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("🚀 Local webhook server started on port \(self.port)")
            case .failed(let error):
                print("❌ Server failed: \(error)")
            case .cancelled:
                print("🛑 Server cancelled")
            default:
                break
            }
        }
        
        listener?.start(queue: .global(qos: .userInitiated))
    }
    
    func stop() {
        listener?.cancel()
        listener = nil
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
        guard let request = String(data: data, encoding: .utf8) else {
            sendResponse(connection: connection, statusCode: 400, body: "Bad Request")
            return
        }
        
        print("📥 Received HTTP request")
        
        // Parse HTTP request
        let lines = request.components(separatedBy: "\r\n")
        guard let firstLine = lines.first else {
            sendResponse(connection: connection, statusCode: 400, body: "Bad Request")
            return
        }
        
        print("📋 Request line: \(firstLine)")
        
        // Accept both /webhook and /receive-message endpoints
        if firstLine.contains("POST /webhook") || firstLine.contains("POST /receive-message") {
            // Extract JSON body
            if let bodyStart = request.range(of: "\r\n\r\n") {
                let bodyString = String(request[bodyStart.upperBound...])
                print("📦 Body: \(bodyString.prefix(200))...")
                
                guard let bodyData = bodyString.data(using: .utf8) else {
                    sendResponse(connection: connection, statusCode: 400, body: "Bad Request")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let webhook = try decoder.decode(WebhookPayload.self, from: bodyData)
                    
                    print("✅ Webhook parsed successfully - Type: \(webhook.type)")
                    
                    DispatchQueue.main.async { [weak self] in
                        switch webhook.data {
                        case .message(let messageData):
                            print("📨 Triggering message callback")
                            self?.onMessageReceived?(messageData)
                            
                        case .status(let statusData):
                            print("📊 Triggering status callback")
                            self?.onStatusUpdate?(statusData)
                        }
                    }
                    
                    sendResponse(connection: connection, statusCode: 200, body: "OK")
                } catch {
                    print("❌ Error parsing webhook: \(error)")
                    print("📄 Raw body: \(bodyString)")
                    sendResponse(connection: connection, statusCode: 400, body: "Bad Request: \(error.localizedDescription)")
                }
            } else {
                print("❌ No body found in request")
                sendResponse(connection: connection, statusCode: 400, body: "No body")
            }
        } else {
            print("❌ Invalid endpoint: \(firstLine)")
            sendResponse(connection: connection, statusCode: 404, body: "Not Found")
        }
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
