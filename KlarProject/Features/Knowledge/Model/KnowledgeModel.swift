//
//  KnowledgeModel.swift
//  KlarProject
//
//  Created by Nicholas Tristandi on 10/11/25.
//

import Foundation


struct PDFDocument : Identifiable, Codable{
    let id : UUID
    let title : String
    let fileURL: URL
    let dateAdded: Date
    
    init(title : String, fileURL : URL, dateAdded : Date = Date()){
        self.id = UUID()
        self.title = title
        self.fileURL = fileURL
        self.dateAdded = dateAdded
    }
    
    var formattedDateAdded: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: dateAdded)
    }
}


extension PDFDocument {
    static let dummyPDFs: [PDFDocument] = [
        PDFDocument(
            title: "SwiftUI Basics",
            fileURL: URL(fileURLWithPath: "/Users/nicholas/Documents/SwiftUI_Basics.pdf"),
            dateAdded: Date()
        ),
        PDFDocument(
            title: "Machine Learning Notes",
            fileURL: URL(fileURLWithPath: "/Users/nicholas/Documents/ML_Notes.pdf"),
            dateAdded: Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        ),
        PDFDocument(
            title: "Data Science Report",
            fileURL: URL(fileURLWithPath: "/Users/nicholas/Documents/DataScience_Report.pdf"),
            dateAdded: Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        )
    ]
}
