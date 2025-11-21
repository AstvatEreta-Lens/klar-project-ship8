# Quick Start - Backend Integration

## 🚀 TL;DR - What You Need to Do

### **Option 1: Use Mock Service (For Now)**
Sudah siap! MockService sudah di-setup. Kode saat ini menggunakan `EvaluationViewModel.shared` yang persistent.

**Status**: ✅ **Working** - Evaluation feature sudah berfungsi dengan data mock

---

### **Option 2: Connect to Real Backend**

**Prerequisites:**
- ✅ Backend API sudah running
- ✅ Punya API key atau authentication token
- ✅ API endpoints sudah implement (lihat `BACKEND_INTEGRATION_GUIDE.md`)

**Steps:**

1. **Update EvaluationViewModel untuk gunakan API Service**

```swift
// File: KlarProject/Features/Knowledge/ViewModel/EvaluationViewModel.swift

private init() {
    // OPTION A: Use Mock Service (Development)
    // self.evaluationService = MockEvaluationService.shared

    // OPTION B: Use API Service (Production)
    self.evaluationService = APIEvaluationService(
        baseURL: "https://your-api.com/api/v1",
        apiKey: "YOUR_API_KEY_HERE"
    )

    Task {
        await loadEvaluations()
    }
}
```

2. **Update ConversationListViewModel untuk gunakan API Service**

```swift
// File: KlarProject/Features/Conversation Page/ViewModels/ConversationListViewModel.swift

init() {
    // OPTION A: Mock Service
    // self.conversationService = MockConversationService()

    // OPTION B: API Service
    self.conversationService = APIConversationService(
        baseURL: "https://your-api.com/api/v1",
        apiKey: "YOUR_API_KEY_HERE"
    )

    Task {
        await loadConversations()
    }
}
```

3. **Done!** 🎉

---

## 📁 Files Created for Backend Integration

### 1. **Service Layer**
- `KlarProject/Services/EvaluationService.swift` ✅
- `KlarProject/Services/ConversationService.swift` ✅

### 2. **Documentation**
- `BACKEND_INTEGRATION_GUIDE.md` ✅ (Detailed guide)
- `QUICK_START_BACKEND.md` ✅ (This file)

---

## 🔄 Current Flow (With Mock Service)

```
User clicks "Evaluate this conversation"
          ↓
ConversationListViewModel.evaluateMessage()
          ↓
EvaluationViewModel.shared.addConversation()
          ↓
MockEvaluationService.addToEvaluation() [Mock Data]
          ↓
Conversation appears in Evaluation page
```

## 🔄 Future Flow (With Real Backend)

```
User clicks "Evaluate this conversation"
          ↓
ConversationListViewModel.evaluateMessage()
          ↓
EvaluationViewModel.shared.addConversation()
          ↓
APIEvaluationService.addToEvaluation()
          ↓
POST /api/v1/evaluations → Backend Database
          ↓
Response: Updated Conversation
          ↓
UI Updates
```

---

## 🗑️ What to Delete (ONLY After Backend is Ready)

1. **Dummy Data** (ConversationModel.swift)
```swift
// ❌ DELETE THIS (lines 175-498)
extension Conversation {
    static let humanDummyData: [Conversation] = [ ... ]
    static let aiDummyData: [Conversation] = [ ... ]
}
```

2. **Mock Service Usage**
- Replace `MockEvaluationService.shared` → `APIEvaluationService(...)`
- Replace `MockConversationService()` → `APIConversationService(...)`

3. **loadDummyDataForTesting()** (EvaluationViewModel.swift)
- Method ini sudah dihapus, diganti dengan `loadEvaluations()` from API

---

## ✅ Checklist Before Going Live

- [ ] Backend API endpoints sudah ready
- [ ] Test API dengan Postman/Insomnia
- [ ] Response format match dengan Swift models
- [ ] Authentication working (API key/token)
- [ ] Error handling implemented
- [ ] Loading states di UI
- [ ] Test dengan real data
- [ ] Remove dummy data
- [ ] Deploy to production

---

## 📞 Questions?

Read the full guide: `BACKEND_INTEGRATION_GUIDE.md`

**Contact Backend Team For:**
- API base URL
- Authentication credentials
- API documentation
- Testing environment access

---

## 🎯 Summary

### **Current State:**
✅ Evaluation feature works dengan MockService
✅ State persistence dengan Singleton pattern
✅ Service layer sudah ready untuk production

### **To Go Production:**
🔄 Ganti MockService → APIService
🔄 Add API credentials
🔄 Test dengan real backend
❌ Remove dummy data

**Estimated Time**: 1-2 hours (jika backend sudah ready)

---

**Last Updated**: November 14, 2024
