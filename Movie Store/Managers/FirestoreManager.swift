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
    
    func readItems() async {
        let items: [ItemFirestoreModel] = []
        do {
          let snapshot = try await db.collection(Constants.collectionItems).getDocuments()
          for document in snapshot.documents {
              
              let item = ItemFirestoreModel(dictionary: document.data())
              print(item)
              
//            print("\(document.documentID) => \(document.data())")
          }
        } catch {
          print("Error getting documents: \(error)")
        }
    }
}


