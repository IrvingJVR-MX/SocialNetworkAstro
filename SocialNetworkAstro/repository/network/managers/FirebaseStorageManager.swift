import Foundation
import FirebaseStorage
import UIKit

enum FirebaseStorageFolders: String {
    case photos
    case covers
}

class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    let storage = Storage.storage().reference()
    func uploadPhoto(imageData: Data, route: String, completion: @escaping ( Result<String, Error>) -> Void) {
        storage.child(route).putData(imageData, metadata: nil, completion: { _, error in
                if  error != nil {
                    completion(.failure(error!))
                } else {
                    self.storage.child(route).downloadURL(completion: { url, error in
                        if error != nil {
                            completion(.failure(error!))
                        }
                        else{
                            guard let url = url, error == nil else{ return}
                            completion(.success(url.absoluteString))
                        }
                    })
                }
        })
    }
  
    
}

