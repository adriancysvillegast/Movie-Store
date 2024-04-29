//
//  FirestoreManager.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/4/24.
//

import Foundation
import FirebaseFirestore

// MARK: - FirestoreError
enum FirestoreError: Error {
    case errorSaving
    case errorReading
    case errorDeleting
}


// MARK: - FirestoreManager
final class FirestoreManager {
    
    // MARK: - Properties
    static let shared = FirestoreManager()
    
    private let db = Firestore.firestore()
    
    
    // MARK: - Methods
    
    
    func addItem(id: String, type: String) async throws -> Bool {
        do {
            let ref = try await db.collection(Constants.collectionItems).addDocument(data: [
                "id": id,
                "type": type
            ])
            print("Document added with ID: \(ref.documentID)")
            return true
        } catch {
            print("Error adding document: \(error.localizedDescription)")
            throw FirestoreError.errorSaving
            
        }
    }
    
    func readItems() async throws -> [ItemFirestoreModel] {
        var items: [ItemFirestoreModel] = []
        
        do {
          let snapshot = try await db.collection(Constants.collectionItems).getDocuments()
          for document in snapshot.documents {
              guard let item = ItemFirestoreModel(dictionary: document.data()) else {
                  throw FirestoreError.errorReading
              }
              items.append(item)
          }
            return items
            
        } catch {
          print("Error getting documents: \(error)")
            throw FirestoreError.errorReading
        }
    }
    
    func delete(id: String) async throws -> Bool {
        do {
            try await db.collection(Constants.collectionItems).document(id).delete()
            return true
        } catch {
            throw FirestoreError.errorDeleting
        }
    }
}


