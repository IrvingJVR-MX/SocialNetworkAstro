import Foundation

public class Register {
    var imageData: Data?
    var register = { () -> () in}
    var registerUser : Bool = false {
        didSet {
            register()
        }
    }
       
    func registerUser (_ email:String, _ password:String, _ username:String ){
        AuthFirebaseManager.shared.registerUser(email: email, password: password) { result in
            switch result {
            case .success(let userId):
                self.savePhoto( userId , username, email)
            case .failure(_):
                self.registerUser = false
            }
        }
    }
    
    
    func savePhoto(_ userId:String, _ username : String, _ email: String){
        guard let imageDataStorage = imageData else{ return }
        let timestamp = NSDate().timeIntervalSince1970
        let route = userId + "/ProfilePhoto/"+"ProfilePhoto"+"\(timestamp)"+".png"

        FirebaseStorageManager.shared.uploadPhoto(imageData: imageDataStorage, route: route, completion: { result in
            switch result {
            case .success(let url):
                self.createUser( userId , username, email,  url, route )
            case .failure(_):
                self.registerUser = false
            }
        })
    }
    
    func createUser (_ userId:String, _ userName:String, _ email:String, _ url: String , _ path: String ) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        let user = UserB(id: userId, name: userName, email: email, createdAt: dateFormatter.string(from: date), photoUrl: url, photoPath: path)
        FirebaseManager.shared.addUser(document: user, collection: .Users, userId: userId, completion: { result in
            switch result {
            case .success(_):
                self.registerUser = true
            case .failure(_):
                self.registerUser = false
            }
        })
        
    }

    
}
