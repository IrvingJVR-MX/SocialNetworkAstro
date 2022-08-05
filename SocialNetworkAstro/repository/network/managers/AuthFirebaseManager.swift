import Foundation
import FirebaseAuth

class AuthFirebaseManager {
    static let shared = AuthFirebaseManager()
    
    public func login(email: String, password: String, completion: @escaping ( Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if  let result = result, error == nil {
                completion(.success(result.user.uid))
            }else {
                completion(.failure(error!))
            }
        }
        
    }
}

