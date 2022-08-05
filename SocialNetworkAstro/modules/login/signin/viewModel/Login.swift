import Foundation
import UIKit
import CoreData

public class Login {
    var authLogin = { () -> () in}
    var userID : String = "" {
        didSet {
            authLogin()
        }
    }
    var userObject: UserF?

    func authUser (_ email: String, _ password: String){
        AuthFirebaseManager.shared.login(email: email, password: password) { result in
            switch result {
            case .success(let userId):
                self.getUserInfo(userId)
            case .failure(_):
                self.userID = ""
            }
        }
    }
        
    func getUserInfo(_ userId: String){
        FirebaseManager.shared.getOneDocument(type: UserF.self, forCollection: .Users, id: userId) { result in
            switch result {
            case .success(let user):
                self.userObject = user
                self.saveUserInfo()
            case .failure(_):
                self.userID = ""
            }
        }
    }
    

    
    func saveUserInfo () {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            do{
                let result = try context.fetch(fetchRequest)
                if result.isEmpty == true {
                    guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context) else { return }
                    guard let user = NSManagedObject(entity: entity, insertInto: context) as? User else { return }
                    user.userid =  userObject?.id
                    user.photoUrl = userObject?.photoUrl
                    user.name = userObject?.name
                    user.email = userObject?.email
                    user.photoPath = userObject?.photoPath
                    try context.save()
                }
            }catch(let error){
                print ("error", error)
            }
            self.userID = userObject?.id ?? ""
        
    }
    

    func checkIfUserIsLoginIn(){
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
         let context = appDelegate.persistentContainer.viewContext
         let fetchRequest = NSFetchRequest<User>(entityName: "User")
         do{
             let dbUser = try context.fetch(fetchRequest)
             if dbUser.isEmpty == false {
                 self.userID = dbUser[0].userid ?? ""
             }
         }catch(let error){
             print ("error", error)
         }
       }
    
}
