//
//  FireStoreStorage.swift
//  CoffeShop
//
//  Created by A.Stelmakh on 24.07.2023.
//

import Foundation
import FirebaseStorage

class FireStoreStorage {
    
    static let shared = FireStoreStorage(); private init() { }
    
    private var storage = Storage.storage().reference()
    
    var productsRef: StorageReference {
        storage.child("menu")
    }
    var caffesRef: StorageReference {
        storage.child("CoffeShop")
    }
    func addImage(image: Data, productID: String, reference: StorageReference) async throws {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
            reference.child(productID).putData(image, metadata: metadata)
        }
    func getImage(productID: String,reference: StorageReference, completion: @escaping (Result<Data, Error>) -> ()){
        reference.child(productID).getData(maxSize: 2 * 1024 * 1024) { data, error in
            guard let data = data else {
                if let error = error{
                    completion(.failure(error))
                }
                return
            }
            completion(.success(data))
        }
    }
}
