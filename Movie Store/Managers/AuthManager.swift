//
//  AuthManager.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class AuthManager {
    // MARK: - Properties
    var db: DatabaseReference?

    var user: User? = {
        guard let user = Auth.auth().currentUser else { return nil }
        return user
    }()

    // MARK: - Methods

    func createNewUser(email: String,
                       password: String,
                       success: @escaping(Bool) -> Void) {
        Auth.auth().createUser(
            withEmail: email,
            password: password
        ) { authResponse, error in

            guard let response = authResponse, error == nil else {
                success(false)
                return
            }


//            self.saveUserName(user: response.user, userName: userName)
            success(true)
            print(response.user)

        }
    }

    func logIn(email: String,
               password: String,
               success: @escaping (Bool) -> Void ) {
        Auth.auth().signIn(
            withEmail: email,
            password: password
        ) {  authResponse, error in

            if error != nil {
                success(false)
            }else {
                success(true)
            }

        }
    }

    func logOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch  {
            return false
        }
    }

    func isSectionActive() -> Bool {
        if let _ = Auth.auth().currentUser?.email {
            return true
        }else {
            return false
        }
    }

    // MARK: - Save username

    func saveUserName(user: User, userName: String) {
        print(user.email ?? "without Email Address")
//        self.db?.child("users").child(user.uid).setValue(["username" : userName])
//        self.db?.child("emails").child(user.uid).setValue(["email" : user.email])
    }
}
