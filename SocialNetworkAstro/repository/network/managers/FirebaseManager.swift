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
    
    

    
}
