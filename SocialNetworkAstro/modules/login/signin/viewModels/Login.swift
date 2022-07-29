import Foundation
import FirebaseAuth
import FirebaseFirestore
import UIKit
import CoreData
import AVFoundation

public class Login {
    var authLogin = { () -> () in}
    var userID : String = "" {
        didSet {
            authLogin()
        }
    }
    var userObject: UserF?
    var db = Firestore.firestore()
    func authUser (_ email: String, _ password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if  let result = result, error == nil {
                self.getUserInfo(result.user.uid)
            }else {
                self.userID = ""
            }
        }
    }
    
    func getUserInfo(_ userId: String){
        db.collection("Users").document(userId).getDocument { docSnapshot, error in
            if error == nil {
                guard let user = try? docSnapshot!.data(as: UserF.self) else { return }
                self.userObject = user
                self.saveUserInfo()
            }else{
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
