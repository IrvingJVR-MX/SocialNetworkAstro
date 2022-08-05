import Foundation
import FirebaseFirestore
import FirebaseStorage

enum FirebaseErrors: Error {
    case ErrorToDecodeItem
    case InvalidUser
}

enum FirebaseCollections: String {
    case Users
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

    
}
