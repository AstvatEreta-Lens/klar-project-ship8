# Backend Integration Guide - Evaluation Feature

## 📊 Overview
Panduan lengkap untuk migrasi dari dummy data ke backend API untuk fitur Evaluation dan Conversation.

---

## 🎯 Yang Perlu Dilakukan

### 1️⃣ **Buat Service Layer untuk Evaluation**

File baru yang perlu dibuat: `KlarProject/Features/Knowledge/Service/EvaluationService.swift`

```swift
import Foundation

// MARK: - Protocol
protocol EvaluationServiceProtocol {
    // Fetch all conversations yang bisa di-evaluate (resolved, not yet evaluated)
    func fetchEvaluableConversations() async throws -> [Conversation]

    // Fetch conversations yang sudah evaluated
    func fetchEvaluatedConversations() async throws -> [Conversation]

    // Add conversation to evaluation queue
    func addToEvaluation(conversationId: UUID) async throws -> Conversation

    // Approve/evaluate conversation
    func approveConversation(conversationId: UUID) async throws -> Conversation

    // Remove conversation from evaluation
    func removeFromEvaluation(conversationId: UUID) async throws
}

// MARK: - API Service (Production)
class APIEvaluationService: EvaluationServiceProtocol {
    private let baseURL: String
    private let apiKey: String

    init(baseURL: String = "https://your-api.com/api/v1", apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }

    func fetchEvaluableConversations() async throws -> [Conversation] {
        // GET /evaluations/unevaluated
        let url = URL(string: "\(baseURL)/evaluations/unevaluated")!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([Conversation].self, from: data)
    }

    func fetchEvaluatedConversations() async throws -> [Conversation] {
        // GET /evaluations/evaluated
        let url = URL(string: "\(baseURL)/evaluations/evaluated")!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([Conversation].self, from: data)
    }

    func addToEvaluation(conversationId: UUID) async throws -> Conversation {
        // POST /evaluations
        let url = URL(string: "\(baseURL)/evaluations")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["conversation_id": conversationId.uuidString]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Conversation.self, from: data)
    }

    func approveConversation(conversationId: UUID) async throws -> Conversation {
        // PATCH /evaluations/{id}/approve
        let url = URL(string: "\(baseURL)/evaluations/\(conversationId)/approve")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Conversation.self, from: data)
    }

    func removeFromEvaluation(conversationId: UUID) async throws {
        // DELETE /evaluations/{id}
        let url = URL(string: "\(baseURL)/evaluations/\(conversationId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let (_, _) = try await URLSession.shared.data(for: request)
    }
}
```

---

### 2️⃣ **Update EvaluationViewModel**

**File**: `KlarProject/Features/Knowledge/ViewModel/EvaluationViewModel.swift`

**Yang perlu diubah:**

```swift
@MainActor
class EvaluationViewModel: ObservableObject {

    static let shared = EvaluationViewModel()

    @Published var selectedConversation: Conversation?
    @Published var evaluatedConversations: [Conversation] = []
    @Published var unevaluatedConversations: [Conversation] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // Inject service
    private let evaluationService: EvaluationServiceProtocol

    private init(evaluationService: EvaluationServiceProtocol = APIEvaluationService(apiKey: "YOUR_API_KEY")) {
        self.evaluationService = evaluationService
        Task {
            await loadEvaluations()
        }
    }

    // MARK: - Load from Backend
    func loadEvaluations() async {
        isLoading = true
        errorMessage = nil

        do {
            // Fetch from API instead of dummy data
            let unevaluated = try await evaluationService.fetchEvaluableConversations()
            let evaluated = try await evaluationService.fetchEvaluatedConversations()

            self.unevaluatedConversations = unevaluated.sorted {
                ($0.resolvedAt ?? Date()) > ($1.resolvedAt ?? Date())
            }

            self.evaluatedConversations = evaluated.sorted {
                ($0.evaluatedAt ?? Date()) > ($1.evaluatedAt ?? Date())
            }

            isLoading = false
        } catch {
            errorMessage = "Failed to load evaluations: \(error.localizedDescription)"
            isLoading = false
        }
    }

    // MARK: - Add Conversation (from Evaluate button)
    func addConversation(_ conversation: Conversation) {
        Task {
            do {
                let updated = try await evaluationService.addToEvaluation(conversationId: conversation.id)
                unevaluatedConversations.insert(updated, at: 0)
                print("✅ Added to evaluation: \(conversation.name)")
            } catch {
                errorMessage = "Failed to add conversation: \(error.localizedDescription)"
            }
        }
    }

    // MARK: - Approve Conversation
    func approveConversation(_ conversation: Conversation) {
        Task {
            do {
                let approved = try await evaluationService.approveConversation(conversationId: conversation.id)

                // Remove from unevaluated
                unevaluatedConversations.removeAll { $0.id == conversation.id }

                // Add to evaluated
                evaluatedConversations.insert(approved, at: 0)

                // Deselect
                selectedConversation = nil

                print("✅ Conversation approved: \(conversation.name)")
            } catch {
                errorMessage = "Failed to approve: \(error.localizedDescription)"
            }
        }
    }

    // MARK: - Remove Conversation
    func removeConversation(_ conversation: Conversation) {
        Task {
            do {
                try await evaluationService.removeFromEvaluation(conversationId: conversation.id)

                unevaluatedConversations.removeAll { $0.id == conversation.id }
                evaluatedConversations.removeAll { $0.id == conversation.id }

                if selectedConversation?.id == conversation.id {
                    selectedConversation = nil
                }

                print("✅ Conversation removed")
            } catch {
                errorMessage = "Failed to remove: \(error.localizedDescription)"
            }
        }
    }
}
```

---

### 3️⃣ **Update ConversationListViewModel**

**File**: `KlarProject/Features/Conversation Page/ViewModels/ConversationListViewModel.swift`

**Yang perlu diubah:**

```swift
@MainActor
class ConversationListViewModel: ObservableObject {
    // ... existing properties ...

    private let conversationService: ConversationServiceProtocol

    init(conversationService: ConversationServiceProtocol = APIConversationService(apiKey: "YOUR_API_KEY")) {
        self.conversationService = conversationService
        Task {
            await loadConversations()
        }
    }

    // MARK: - Load from Backend
    func loadConversations() async {
        do {
            let conversations = try await conversationService.fetchConversations()

            // Separate by handler type
            self.humanConversations = conversations.filter { $0.handlerType == .human }
            self.aiConversations = conversations.filter { $0.handlerType == .ai }

        } catch {
            print("Failed to load conversations: \(error)")
        }
    }

    // MARK: - Resolve Conversation
    func resolveConversation() {
        guard let selected = selectedConversation else { return }

        Task {
            do {
                let resolved = try await conversationService.resolveConversation(id: selected.id)

                // Update local state
                if let index = aiConversations.firstIndex(where: { $0.id == selected.id }) {
                    aiConversations[index] = resolved
                } else if let index = humanConversations.firstIndex(where: { $0.id == selected.id }) {
                    humanConversations[index] = resolved
                }

                selectedConversation = resolved
            } catch {
                print("Failed to resolve: \(error)")
            }
        }
    }
}
```

---

## 🗑️ Yang Bisa Dihapus

### ❌ Dummy Data di ConversationModel.swift

**File**: `KlarProject/Shared/Model/ConversationModel.swift`

**Hapus seluruh bagian ini** (lines 175-498):

```swift
// MARK: - Dummy Data
extension Conversation {
    static let humanDummyData: [Conversation] = [ ... ]
    static let aiDummyData: [Conversation] = [ ... ]
}
```

**⚠️ PENTING:** Hapus ini HANYA setelah backend sudah siap dan API integration sudah berfungsi!

---

### ❌ loadDummyDataForTesting() di EvaluationViewModel

**File**: `KlarProject/Features/Knowledge/ViewModel/EvaluationViewModel.swift`

**Hapus method ini** (lines 38-47):

```swift
// MARK: - Load dummy data for testing only
private func loadDummyDataForTesting() {
    let testEvaluated = Conversation.aiDummyData.filter { $0.isEvaluated == true }
    evaluatedConversations = testEvaluated
        .sorted { ($0.evaluatedAt ?? Date()) > ($1.evaluatedAt ?? Date()) }

    unevaluatedConversations = []
}
```

Ganti dengan `await loadEvaluations()` di init.

---

### ❌ MockInternalNotesService (Optional)

**File**: `KlarProject/Features/Conversation Detail/Component/Internal Notes/InternalNotesService-FullAI.swift`

Hapus class `MockInternalNotesService` dan gunakan `APIInternalNotesService` setelah implement API-nya.

---

### ❌ MockAISummaryService (Optional)

**File**: `KlarProject/Features/Conversation Detail/Component/AISummary/AISummaryService.swift`

Hapus class `MockAISummaryService` dan gunakan `APIAISummaryService` setelah implement API-nya.

---

## 📡 API Endpoints yang Dibutuhkan

### **Evaluation Endpoints:**

```
GET    /api/v1/evaluations/unevaluated
       → Response: [Conversation]
       → Deskripsi: Fetch conversations yang sudah resolved tapi belum di-evaluate

GET    /api/v1/evaluations/evaluated
       → Response: [Conversation]
       → Deskripsi: Fetch conversations yang sudah di-approve/evaluate

POST   /api/v1/evaluations
       → Body: { "conversation_id": "uuid" }
       → Response: Conversation
       → Deskripsi: Add conversation ke evaluation queue

PATCH  /api/v1/evaluations/{conversation_id}/approve
       → Response: Conversation
       → Deskripsi: Approve/evaluate conversation

DELETE /api/v1/evaluations/{conversation_id}
       → Response: 204 No Content
       → Deskripsi: Remove conversation from evaluation
```

### **Conversation Endpoints:**

```
GET    /api/v1/conversations
       → Response: [Conversation]
       → Deskripsi: Fetch all conversations (human + AI)

GET    /api/v1/conversations/{id}
       → Response: Conversation
       → Deskripsi: Fetch single conversation detail

PATCH  /api/v1/conversations/{id}/resolve
       → Response: Conversation
       → Deskripsi: Mark conversation as resolved

PATCH  /api/v1/conversations/{id}/takeover
       → Body: { "user_id": "uuid" }
       → Response: Conversation
       → Deskripsi: Take over AI conversation (convert to human)

POST   /api/v1/conversations/{id}/notes
       → Body: { "message": "string", "author_id": "uuid" }
       → Response: InternalNote
       → Deskripsi: Add internal note

DELETE /api/v1/conversations/{id}/notes/{note_id}
       → Response: 204 No Content
       → Deskripsi: Delete internal note
```

### **AI Summary Endpoints:**

```
GET    /api/v1/conversations/{id}/summary
       → Response: AISummary
       → Deskripsi: Fetch existing AI summary

POST   /api/v1/conversations/{id}/summary
       → Body: { "messages": [Message] }
       → Response: AISummary
       → Deskripsi: Generate new AI summary

DELETE /api/v1/conversations/{id}/summary
       → Response: 204 No Content
       → Deskripsi: Delete AI summary
```

---

## 📝 JSON Response Format

### Conversation Object:

```json
{
  "id": "uuid",
  "name": "Customer Name",
  "message": "Last message content",
  "time": "14.29",
  "profile_image": "url or filename",
  "unread_count": 2,
  "has_whatsapp": true,
  "phone_number": "+62-xxx-xxx",
  "handler_type": "ai" | "human",
  "status": "pending" | "open" | "resolved" | null,
  "label": ["maintenance", "service"],
  "handled_by": {
    "id": "uuid",
    "name": "Agent Name",
    "email": "agent@example.com",
    "profile_image": "url"
  },
  "handled_at": "14.29",
  "handled_date": "2024-11-14T14:29:00Z",
  "is_evaluated": false,
  "evaluated_at": "2024-11-14T15:00:00Z" | null,
  "resolved_at": "2024-11-14T14:30:00Z" | null,
  "seen_by": [
    {
      "id": "uuid",
      "user": { ... },
      "seen_at": "14.30"
    }
  ],
  "internal_notes": [
    {
      "id": "uuid",
      "conversation_id": "uuid",
      "author": { ... },
      "message": "Note content",
      "timestamp": "2024-11-14T14:25:00Z"
    }
  ]
}
```

---

## 🔄 Migration Steps (Step-by-Step)

### **Phase 1: Setup (Tanpa Break Existing Code)**

1. ✅ Buat file `EvaluationService.swift` dengan protocol + API service
2. ✅ Buat file `ConversationService.swift` dengan protocol + API service
3. ✅ Test API endpoints menggunakan Postman/Insomnia
4. ✅ Pastikan response format sesuai dengan model Swift

### **Phase 2: Integration (Gradual Replacement)**

5. ✅ Update `EvaluationViewModel` untuk inject service (keep dummy as fallback)
6. ✅ Update `ConversationListViewModel` untuk inject service
7. ✅ Test dengan backend API di development environment
8. ✅ Fix any mapping/parsing issues

### **Phase 3: Cleanup (Remove Dummy Data)**

9. ✅ Hapus `loadDummyDataForTesting()` dari EvaluationViewModel
10. ✅ Hapus dummy data dari ConversationModel.swift
11. ✅ Hapus Mock services (MockInternalNotesService, MockAISummaryService)
12. ✅ Final testing dengan production API

---

## 🛠️ Service Layer Structure (Recommended)

Buat folder structure seperti ini:

```
KlarProject/
├── Services/
│   ├── Network/
│   │   ├── APIClient.swift          # Base HTTP client
│   │   ├── APIEndpoint.swift        # Endpoint definitions
│   │   └── APIError.swift           # Error handling
│   ├── Conversation/
│   │   ├── ConversationService.swift
│   │   └── ConversationServiceProtocol.swift
│   ├── Evaluation/
│   │   ├── EvaluationService.swift
│   │   └── EvaluationServiceProtocol.swift
│   └── Authentication/
│       └── AuthService.swift         # API key / token management
```

---

## ⚠️ Important Notes

1. **Authentication**: Semua API calls perlu Bearer token atau API key
2. **Error Handling**: Implement proper error handling untuk network failures
3. **Loading States**: Tambahkan loading indicators di UI
4. **Caching**: Consider implement local caching untuk offline support
5. **Date Format**: Backend harus return ISO8601 format untuk dates
6. **Testing**: Test dengan edge cases (empty lists, network errors, etc.)

---

## 🎯 Summary

### **Keep (Untuk Sementara):**
- ✅ Dummy data sebagai fallback selama development
- ✅ Mock services untuk unit testing
- ✅ Existing model structures

### **Replace:**
- 🔄 `loadDummyDataForTesting()` → `loadEvaluations()` from API
- 🔄 `Conversation.aiDummyData` → API fetch
- 🔄 Local state management → Backend sync

### **Delete (After Backend Ready):**
- ❌ All dummy data extensions
- ❌ Mock service implementations
- ❌ Hardcoded test users

---

## 📞 Questions to Ask Backend Team

1. What's the base URL for API? (staging vs production)
2. How to get API key / authentication token?
3. What's the pagination strategy for conversations list?
4. Are there rate limits on API calls?
5. What's the expected response time for AI summary generation?
6. Is there WebSocket support for real-time updates?
7. What's the error response format?

---

**Last Updated**: November 14, 2024
**Author**: Claude Code Assistant
**Project**: Klar Project - Evaluation Feature
