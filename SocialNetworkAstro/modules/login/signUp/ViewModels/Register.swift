import Foundation
import FirebaseAuth
import FirebaseFirestore

public class Register {
    let db = Firestore.firestore()
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
        let user = UserF(id: userId, name: userName, email: email, createdAt: dateFormatter.string(from: date))
        let newFirebaseDocument = db.collection("Users").document(userId)
        let fakeFollowed = userFollowedDetail(id: "", name: "", profilePhotoUrl: "" )
        newFirebaseDocument.setData(user.dictionary)
        newFirebaseDocument.collection("Friends").document().setData(fakeFollowed.dictionary, completion: { error in
            if error == nil{
                self.registerUser = true
            } else{
                self.registerUser = false
            }
        })
    }
    
    
}
