import Foundation
import FirebaseAuth

public class Register {
    let firebaseManager = FirebaseManager.shared
    var register = { () -> () in}
    var registerUser : Bool = false {
        didSet {
            register()
        }
    }
       
    func registerUser (_ email:String, _ password:String, _ username:String ){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                let userId =  "\(result?.user.uid ?? "")"
                self.createUser( userId , username, email)
            }else {
                self.registerUser = false
            }
        }
    }
    

    func createUser (_ userId:String, _ userName:String, _ email:String ) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        let user = User(id: userId, name: userName, email: email, createdAt: dateFormatter.string(from: date))
        firebaseManager.addDocument(document: user, collection: .Users) { result in
            switch result {
            case .success:
                self.registerUser = true
            case .failure:
                self.registerUser = false
            }
        }
    }
    
    
    
    
}
