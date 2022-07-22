import Foundation
import FirebaseAuth
import UIKit
import CoreData

public class Login {
    var authLogin = { () -> () in}
    var userID : String = "" {
        didSet {
            authLogin()
        }
    }
       
    func authUser (_ email: String, _ password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let result = result, error == nil {
                self.userID = result.user.uid
                self.saveUserInfo()
            }else {
                self.userID = ""
            }
        }
    }
    
    func saveUserInfo () {
        if !self.userID.isEmpty {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            do{
                let result = try context.fetch(fetchRequest)
                if result.isEmpty == true {
                    guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context) else { return }
                    guard let user = NSManagedObject(entity: entity, insertInto: context) as? User else { return }
                    user.userid =  userID
                    try context.save()
                }
            }catch(let error){
                print ("error", error)
            }
        }
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
             /*if let userId = dbUser[0].userid, !userId.isEmpty {
                 self.userID = userId
             }*/
         }catch(let error){
             print ("error", error)
         }
       }
    
}
