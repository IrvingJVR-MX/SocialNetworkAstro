import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

public class Register {
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    var imageData: Data?
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
                self.savePhoto( userId , username, email)
            }else {
                self.registerUser = false
            }
        }
    }
    
    func savePhoto(_ userId:String, _ username : String, _ email: String){
        guard let imageDataStorage = imageData else{ return }
        storage.child(userId + "/ProfilePhoto/"+"ProfilePhoto"+".png").putData(imageDataStorage, metadata: nil, completion: { _, error in
            guard error == nil else{
                self.registerUser = false
                return
            }
            self.storage.child(userId + "/ProfilePhoto/"+"ProfilePhoto"+".png").downloadURL(completion: { url, error in
                           guard let url = url, error == nil else{
                               return
                           }
                            self.createUser( userId , username, email,  url.absoluteString  )
                      })
        })
    }
    

    func createUser (_ userId:String, _ userName:String, _ email:String, _ url: String ) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        let user = UserF(id: userId, name: userName, email: email, createdAt: dateFormatter.string(from: date), photoUrl: url)
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
