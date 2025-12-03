//
//  server2_1.js
//  KlarProject
//
//  Created by Ahmad Al Wabil on 25/11/25.
//

const express = require("express");
const bodyParser = require("body-parser");
const axios = require("axios");
const cors = require("cors");
require("dotenv").config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(bodyParser.json());
app.use(cors());

const VERIFY_TOKEN = process.env.VERIFY_TOKEN || "default_token";
const WHATSAPP_TOKEN = process.env.WHATSAPP_TOKEN;
const PHONE_NUMBER_ID = process.env.PHONE_NUMBER_ID;
const WHATSAPP_API_URL = "https://graph.facebook.com/v22.0";

const connectedClients = new Map();
const messageHistory = new Map();
const processedMessages = new Map(); // ✅ UBAH: Track ALL processed messages, bukan hanya AI replies
const sentMessages = new Map();

app.post("/api/register", (req, res) => {
    const { clientId, callbackUrl } = req.body;

    if (!clientId || !callbackUrl) {
        return res.status(400).json({
            success: false,
            error: "clientId and callbackUrl required"
        });
    }

    if (connectedClients.has(clientId)) {
        console.log(`🔄 Re-registering client: ${clientId}`);
    }

    connectedClients.set(clientId, {
        callbackUrl,
        registeredAt: new Date().toISOString()
    });

    console.log(`✅ Client registered: ${clientId}`);
    console.log(`📊 Total active clients: ${connectedClients.size}`);

    res.json({
        success: true,
        clientId,
        message: "Client successfully registered"
    });
});

app.post("/api/unregister", (req, res) => {
    const { clientId } = req.body;

    if (connectedClients.has(clientId)) {
        connectedClients.delete(clientId);
        console.log(`👋 Client unregistered: ${clientId}`);
        res.json({ success: true, message: "Unregistered" });
    } else {
        res.status(404).json({ success: false, error: "Client not found" });
    }
});

app.post("/api/send-message", async (req, res) => {
    const { to, message, type = "text", clientId } = req.body;

    if (!to || !message) {
        return res.status(400).json({
            success: false,
            error: "to and message fields required"
        });
    }

    if (!WHATSAPP_TOKEN || !PHONE_NUMBER_ID) {
        return res.status(500).json({
            success: false,
            error: "WhatsApp credentials not configured"
        });
    }

    try {
        const payload = {
            messaging_product: "whatsapp",
            to: to,
            type: type,
            text: { body: message }
        };

        const response = await axios.post(
            `${WHATSAPP_API_URL}/${PHONE_NUMBER_ID}/messages`,
            payload,
            {
                headers: {
                    "Authorization": `Bearer ${WHATSAPP_TOKEN}`,
                    "Content-Type": "application/json"
                }
            }
        );

        const messageData = {
            messageId: response.data.messages[0].id,
            to: to,
            text: message,
            timestamp: new Date().toISOString(),
            status: "sent",
            isFromMe: true
        };

        if (!messageHistory.has(to)) {
            messageHistory.set(to, []);
        }
        messageHistory.get(to).push(messageData);

        console.log(`📤 Message sent to ${to}`);

        res.json({
            success: true,
            messageId: response.data.messages[0].id,
            message: messageData
        });

    } catch (error) {
        console.error("❌ Error sending message:", error.response?.data || error.message);
        res.status(500).json({
            success: false,
            error: "Failed to send message",
            details: error.response?.data || error.message
        });
    }
});

app.post("/api/send-from-engine", async (req, res) => {
    const { user_id, reply } = req.body;

    if (!user_id || !reply) {
        return res.status(400).json({
            success: false,
            error: "user_id and reply required",
        });
    }

    const messageKey = `${user_id}_${reply.substring(0, 50)}_${Date.now() - (Date.now() % 5000)}`;
    if (sentMessages.has(messageKey)) {
        console.log("⚠️ Duplicate send-from-engine request, skipping:", messageKey);
        return res.json({
            success: true,
            messageId: sentMessages.get(messageKey),
            reply,
            cached: true
        });
    }

    try {
        const payload = {
            messaging_product: "whatsapp",
            to: user_id,
            type: "text",
            text: { body: reply }
        };

        const response = await axios.post(
            `${WHATSAPP_API_URL}/${PHONE_NUMBER_ID}/messages`,
            payload,
            {
                headers: {
                    Authorization: `Bearer ${WHATSAPP_TOKEN}`,
                    "Content-Type": "application/json",
                },
            }
        );

        const messageId = response.data.messages[0].id;

        sentMessages.set(messageKey, messageId);
        setTimeout(() => sentMessages.delete(messageKey), 5000);

        console.log("📤 Engine reply sent to:", user_id);

        res.json({
            success: true,
            messageId: messageId,
            reply,
        });

    } catch (error) {
        console.error("❌ Error sending engine reply:", error.response?.data || error.message);
        res.status(500).json({
            success: false,
            error: "Failed sending WA message",
            details: error.response?.data || error.message,
        });
    }
});

app.get("/api/messages/:phoneNumber", (req, res) => {
    const { phoneNumber } = req.params;
    const messages = messageHistory.get(phoneNumber) || [];

    res.json({
        success: true,
        phoneNumber,
        messages
    });
});

app.get("/api/conversations", (req, res) => {
    const conversations = [];

    for (const [phoneNumber, messages] of messageHistory.entries()) {
        const lastMessage = messages[messages.length - 1];
        conversations.push({
            phoneNumber,
            lastMessage: lastMessage.text,
            timestamp: lastMessage.timestamp,
            unreadCount: 0,
            messageCount: messages.length
        });
    }

    res.json({
        success: true,
        conversations
    });
});

app.get("/webhook", (req, res) => {
    const mode = req.query["hub.mode"];
    const token = req.query["hub.verify_token"];
    const challenge = req.query["hub.challenge"];

    console.log("🔍 Webhook verification request");

    if (mode === "subscribe" && token === VERIFY_TOKEN) {
        console.log("✅ Webhook verified!");
        res.status(200).send(challenge);
    } else {
        console.log("❌ Verification failed!");
        res.sendStatus(403);
    }
});

app.post("/webhook", async (req, res) => {
    console.log("\n📩 Incoming webhook:");

    // ✅ RESPOND IMMEDIATELY - Ini yang paling penting!
    res.status(200).send("EVENT_RECEIVED");

    try {
        const body = req.body;

        if (body.object !== "whatsapp_business_account") {
            console.log("⚠️ Ignored non-whatsapp event");
            return;
        }

        // Process async without blocking
        processWebhookAsync(body);

    } catch (error) {
        console.error("❌ Webhook error:", error);
    }
});

// ✅ PISAHKAN PROCESSING KE FUNCTION TERPISAH
async function processWebhookAsync(body) {
    try {
        for (const entry of body.entry || []) {
            for (const change of entry.changes || []) {
                
                // ---- HANDLE MESSAGES ----
                if (change.value.messages) {
                    for (const msg of change.value.messages) {
                        await processIncomingMessage(msg);
                    }
                }

                // ---- HANDLE STATUS UPDATES ----
                if (change.value.statuses) {
                    for (const status of change.value.statuses) {
                        await processStatusUpdate(status);
                    }
                }
            }
        }
    } catch (error) {
        console.error("❌ Async processing error:", error);
    }
}

// ✅ FUNCTION UNTUK PROCESS MESSAGE
async function processIncomingMessage(msg) {
    try {
        console.log("--- 📱 New Message Event ---");
        console.log("From:", msg.from);
        console.log("Type:", msg.type);
        console.log("Message ID:", msg.id);

        // Skip self messages
        if (String(msg.from) === String(PHONE_NUMBER_ID)) {
            console.log("⛔ Skipping message from our own number");
            return;
        }

        // ✅ GLOBAL MESSAGE DEDUPLICATION CHECK
        const messageKey = `${msg.from}_${msg.id}`;
        if (processedMessages.has(messageKey)) {
            console.log("⚠️ Message already processed globally, skipping:", messageKey);
            return;
        }

        // Mark as processing IMMEDIATELY
        processedMessages.set(messageKey, {
            timestamp: Date.now(),
            stage: 'started'
        });

        // Cleanup after 15 minutes
        setTimeout(() => {
            processedMessages.delete(messageKey);
            console.log("🧹 Cleaned up processedMessages for", messageKey);
        }, 15 * 60 * 1000);

        // Prepare message history
        if (!messageHistory.has(msg.from)) {
            messageHistory.set(msg.from, []);
        }
        const existingMessages = messageHistory.get(msg.from);

        // Double check in history
        const isDuplicate = existingMessages.some(m => m.messageId === msg.id);
        if (isDuplicate) {
            console.log("⚠️ Message already in history, skipping:", msg.id);
            return;
        }

        // Build message data
        const messageData = {
            messageId: msg.id,
            from: msg.from,
            timestamp: msg.timestamp || new Date().toISOString(),
            type: msg.type,
            isFromMe: false
        };

        if (msg.type === "text") {
            messageData.text = msg.text?.body || "";
        } else if (msg.type === "image") {
            messageData.image = msg.image;
            messageData.text = msg.image?.caption || "[Image]";
        } else if (msg.type === "audio") {
            messageData.audio = msg.audio;
            messageData.text = "[Audio]";
        } else if (msg.type === "video") {
            messageData.video = msg.video;
            messageData.text = msg.video?.caption || "[Video]";
        } else if (msg.type === "document") {
            messageData.document = msg.document;
            messageData.text = msg.document?.filename || "[Document]";
        } else {
            messageData.text = "[Unsupported]";
        }

        existingMessages.push(messageData);
        messageData.type = "message";
        console.log("💾 Customer message saved to history");

        // Broadcast to clients
        await forwardToClients(messageData);
        console.log("📡 Customer message broadcasted to clients");

        // ✅ AI PROCESSING - Only for text messages
        if (msg.type === "text" && messageData.text) {
            // Update stage
            processedMessages.get(messageKey).stage = 'ai_processing';

            try {
                const fastApiResponse = await axios.post(
                    "https://zoey-posthepatic-dissymmetrically.ngrok-free.dev/chat",
                    {
                        user_id: msg.from,
                        text: messageData.text
                    },
                    {
                        headers: { "Content-Type": "application/json" },
                        timeout: 30000 // 30 second timeout
                    }
                );

                console.log("🤖 FastAPI response:", fastApiResponse.data);

                let aiReplyText = null;
                let aiStatus = null;

                if (fastApiResponse.data?.reply) {
                    aiReplyText = fastApiResponse.data.reply;
                } else if (fastApiResponse.data?.bubbles && Array.isArray(fastApiResponse.data.bubbles)) {
                    const textBubbles = fastApiResponse.data.bubbles
                        .filter(b => b.type === 'text')
                        .map(b => b.text);
                    aiReplyText = textBubbles.join('\n');
                }

                if (fastApiResponse.data?.status) {
                    aiStatus = fastApiResponse.data.status;
                }

                if (!aiReplyText) {
                    console.log("⚠️ FastAPI returned no reply text");
                    return;
                }

                // ✅ Check for duplicate AI reply before sending
                const recentAIReplies = existingMessages
                    .filter(m => m.isAIReply && m.text === aiReplyText)
                    .filter(m => {
                        const msgTime = new Date(m.timestamp).getTime();
                        const now = Date.now();
                        return (now - msgTime) < 60000; // dalam 1 menit terakhir
                    });

                if (recentAIReplies.length > 0) {
                    console.log("⚠️ Identical AI reply already sent recently, skipping");
                    return;
                }

                // Send to WhatsApp
                const aiSendPayload = {
                    messaging_product: "whatsapp",
                    to: msg.from,
                    type: "text",
                    text: { body: aiReplyText }
                };

                const aiReplyResponse = await axios.post(
                    `${WHATSAPP_API_URL}/${PHONE_NUMBER_ID}/messages`,
                    aiSendPayload,
                    {
                        headers: {
                            Authorization: `Bearer ${WHATSAPP_TOKEN}`,
                            "Content-Type": "application/json"
                        }
                    }
                );

                console.log("📤 AI Reply sent to WhatsApp for:", msg.from);

                const sentWhatsAppMessageId = aiReplyResponse.data?.messages?.[0]?.id || `wa_${Date.now()}`;

                const aiMessageData = {
                    messageId: sentWhatsAppMessageId,
                    from: PHONE_NUMBER_ID,
                    to: msg.from,
                    text: aiReplyText,
                    timestamp: new Date().toISOString(),
                    type: "ai_reply",
                    isFromMe: true,
                    isAIReply: true,
                    aiStatus: aiStatus || null
                };

                messageHistory.get(msg.from).push(aiMessageData);
                console.log("💾 AI reply saved to message history");

                await forwardToClients(aiMessageData);
                console.log("📡 AI reply broadcasted to clients");

                // Mark as completed
                processedMessages.get(messageKey).stage = 'completed';

            } catch (aiError) {
                console.error("❌ Error during AI processing:", aiError.response?.data || aiError.message);
                // Don't delete from processedMessages to prevent retry
            }
        }

    } catch (error) {
        console.error("❌ Error processing message:", error);
    }
}

// ✅ FUNCTION UNTUK PROCESS STATUS
async function processStatusUpdate(status) {
    try {
        console.log("--- 📊 Status Update ---");
        console.log("Message ID:", status.id);
        console.log("Status:", status.status);

        const statusData = {
            type: "status",
            messageId: status.id,
            status: status.status,
            timestamp: status.timestamp,
            recipientId: status.recipient_id,
            raw: status
        };

        // Update message history
        for (const [phoneNumber, msgs] of messageHistory.entries()) {
            const msg = msgs.find(m => m.messageId === status.id);
            if (msg) {
                console.log(`📊 Updating message ${status.id} status to ${status.status}`);
                msg.status = status.status;
                msg.statusTimestamp = status.timestamp;
                break;
            }
        }

        await forwardToClients(statusData);
    } catch (error) {
        console.error("❌ Status update error:", error);
    }
}

async function forwardToClients(data) {
    if (connectedClients.size === 0) {
        console.log("⚠️  No clients connected");
        return;
    }

    const payload = {
        type: data.type || "message",
        data,
        timestamp: new Date().toISOString()
    };

    console.log(`📡 Broadcasting to ${connectedClients.size} client(s)`);

    const clientsToRemove = [];

    for (const [clientId, clientInfo] of connectedClients.entries()) {
        try {
            await axios.post(clientInfo.callbackUrl, payload, {
                timeout: 3000,
                headers: { "Content-Type": "application/json" }
            });
            console.log(`✅ Forwarded to client: ${clientId}`);
        } catch (error) {
            console.error(`❌ Failed to forward to ${clientId}:`, error.message);

            if (error.response?.status === 404 || error.code === 'ECONNREFUSED') {
                clientsToRemove.push(clientId);
            }
        }
    }

    for (const clientId of clientsToRemove) {
        connectedClients.delete(clientId);
        console.log(`🗑️  Removed dead client: ${clientId}`);
    }

    if (clientsToRemove.length > 0) {
        console.log(`📊 Active clients: ${connectedClients.size}`);
    }
}

app.get("/api/status", (req, res) => {
    res.json({
        success: true,
        status: "active",
        connectedClients: connectedClients.size,
        totalConversations: messageHistory.size,
        processedMessagesCount: processedMessages.size,
        whatsappConfigured: !!(WHATSAPP_TOKEN && PHONE_NUMBER_ID),
        timestamp: new Date().toISOString()
    });
});

app.get("/api/clients", (req, res) => {
    const clients = Array.from(connectedClients.entries()).map(([id, info]) => ({
        clientId: id,
        callbackUrl: info.callbackUrl,
        registeredAt: info.registeredAt
    }));

    res.json({
        success: true,
        count: clients.length,
        clients
    });
});

app.post("/api/cleanup-clients", (req, res) => {
    const before = connectedClients.size;
    connectedClients.clear();
    console.log(`🧹 Cleaned up ${before} clients`);

    res.json({
        success: true,
        message: `Removed ${before} clients`,
        remaining: connectedClients.size
    });
});

app.get("/", (req, res) => {
    res.json({
        success: true,
        message: "WhatsApp Chat Backend API",
        version: "1.1.0",
        endpoints: {
            register: "POST /api/register",
            sendMessage: "POST /api/send-message",
            getMessages: "GET /api/messages/:phoneNumber",
            conversations: "GET /api/conversations",
            status: "GET /api/status"
        }
    });
});

app.listen(PORT, () => {
    console.log("\n" + "=".repeat(50));
    console.log("🚀 WhatsApp Chat Backend Server");
    console.log("=".repeat(50));
    console.log(`📡 Server running on port ${PORT}`);
    console.log(`🔑 Verify Token: ${VERIFY_TOKEN}`);
    console.log(`📱 WhatsApp configured: ${!!(WHATSAPP_TOKEN && PHONE_NUMBER_ID)}`);
    console.log("✨ Ready to receive connections!");
    console.log("=".repeat(50) + "\n");
});
