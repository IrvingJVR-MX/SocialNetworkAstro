import Foundation
import FirebaseFirestore
import FirebaseStorage

enum FirebaseErrors: Error {
    case ErrorToDecodeItem
    case InvalidUser
}

enum FirebaseCollections: String {
    case Users
    case Friends
    case Post
}

class FirebaseManager {
    static let shared = FirebaseManager()
    let db = Firestore.firestore()
    
    func getOneDocument<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections, id: String, completion: @escaping ( Result<T, Error>) -> Void  ) {
        db.collection(collection.rawValue).document(id).getDocument { document, error in
            if error == nil {
                if let data = document?.data() {
                    let jsonDecoder = JSONDecoder()
                    let dataRaw = try? JSONSerialization.data(withJSONObject: data)
                    let item = try? jsonDecoder.decode(type, from: dataRaw!)
                    completion(.success(item!))
                }
            }else{
                completion(.failure(error!))
            }
        }
    }
    
    func addDocument<T: Encodable & BaseModel >(document: T, collection: FirebaseCollections, completion: @escaping ( Result<T, Error>) -> Void  ) {
        guard let itemDict = document.dict else { return completion(.failure(FirebaseErrors.ErrorToDecodeItem)) }
        
        db.collection(collection.rawValue).document(document.id).setData(itemDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(document))
            }
        }
        
    }
    
    func removeDocument(documentID: String, collection: FirebaseCollections, completion: @escaping ( Result<String, Error>) -> Void  ) {
        db.collection(collection.rawValue).document(documentID).delete() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(documentID))
            }
        }
    }
    
    
    func listenCollectionChanges<T: Decodable>(type: T.Type, collection: FirebaseCollections, completion: @escaping ( Result<[T], Error>) -> Void  ) {
        db.collection(collection.rawValue).addSnapshotListener { querySnapshot, error in
            guard error == nil else { return completion(.failure(error!)) }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            var items = [T]()
            let json = JSONDecoder()
            for document in documents {
                if let data = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let item = try? json.decode(type, from: data) {
                    items.append(item)
                }
            }
            completion(.success(items))
        }
    }
    
    func listenMyPostCollectionChanges<T: Decodable>(type: T.Type, userId: String ,collection: FirebaseCollections, completion: @escaping ( Result<[T], Error>) -> Void  ) {
        db.collection(collection.rawValue).whereField("userID", isEqualTo: userId).addSnapshotListener { querySnapshot, error in
            guard error == nil else { return completion(.failure(error!)) }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            var items = [T]()
            let json = JSONDecoder()
            for document in documents {
                if let data = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let item = try? json.decode(type, from: data) {
                    items.append(item)
                }
            }
            completion(.success(items))
        }
    }
    

    
    
    func removeFollow(userId: String, followedId : String, collection: FirebaseCollections, completion: @escaping ( Result<String, Error>) -> Void  ) {
        
        db.collection(collection.rawValue).document(userId).collection("Friends").document(followedId).delete() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(userId))
            }
        }
    }
    
    
    func addFollow<T: Encodable & BaseModel >(document: T, userId: String, followedId: String ,collection: FirebaseCollections, completion: @escaping ( Result<T, Error>) -> Void  ) {
        guard let itemDict = document.dict else { return completion(.failure(FirebaseErrors.ErrorToDecodeItem)) }
        
        db.collection(collection.rawValue).document(userId).collection("Friends").document(followedId).setData(itemDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(document))
            }
        }
        
    }
   
    
    
    func listenCollectionOfFriends<T: Decodable>(type: T.Type, userId: String ,collection: FirebaseCollections, completion: @escaping ( Result<[T], Error>) -> Void  ) {
        db.collection(collection.rawValue).document(userId).collection("Friends").addSnapshotListener { querySnapshot, error in
            guard error == nil else { return completion(.failure(error!)) }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            var items = [T]()
            let json = JSONDecoder()
            for document in documents {
                if let data = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let item = try? json.decode(type, from: data) {
                    items.append(item)
                }
            }
            completion(.success(items))
        }
    }
   
    
    
    
    func addUser<T: Encodable & BaseModel>(document: T, collection: FirebaseCollections, userId: String, completion: @escaping ( Result<T, Error>) -> Void  ) {
        guard let itemDict = document.dict else { return completion(.failure(FirebaseErrors.ErrorToDecodeItem)) }
        let fakeFollowed = userFollowedDetail(id: "", name: "", profilePhotoUrl: "" )
        let firebaseDocument = db.collection(collection.rawValue).document(userId)
        firebaseDocument.setData(itemDict) { error in
            if error != nil{
                completion(.failure(error!))
            }
        }
        
        firebaseDocument.collection(FirebaseCollections.Friends.rawValue).document().setData(fakeFollowed.dictionary, completion: { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(document))
            }
        })
    }
    
    func addEmptyDocument(collection: FirebaseCollections, completion: @escaping (String) -> Void  ) {
        let postId = db.collection(collection.rawValue).document().documentID
        if postId == "" {
            completion("")
        }else{
            completion(postId)
        }
    }

    
}
