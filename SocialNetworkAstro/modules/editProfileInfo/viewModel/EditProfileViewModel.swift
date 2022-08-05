import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseCore
import FirebaseDatabase
import UIKit
import CoreData
import FirebaseAuth

public class EditProfileViewModel {
    var notifyUpdate = { () -> () in}
    var updated : Bool = false {
        didSet {
            notifyUpdate()
        }
    }
    let storage = Storage.storage().reference()
    let db = Firestore.firestore()
    var imageData: Data?
    var user: User?
    
    func updateUserInfo () {
        if imageData == nil {
            updateUser()
        } else{
            deletePostPhoto()
        }
    }
    
    func deletePostPhoto () {
        storage.child(user?.photoPath ?? "").delete(completion: { error in
            if error == nil {
                self.saveProfilePhoto()
            }
        })
        
    }
    
    func saveProfilePhoto(){
        let timestamp = NSDate().timeIntervalSince1970
        guard let imageDataStorage = imageData else{ return }
        let userId = user?.userid ?? ""
        storage.child(userId + "/ProfilePhoto/"+"ProfilePhoto"+"\(timestamp)"+".png").putData(imageDataStorage, metadata: nil, completion: { _, error in
            guard error == nil else{
                print("Failed")
                return
            }
            self.storage.child(userId + "/ProfilePhoto/"+"ProfilePhoto"+"\(timestamp)"+".png").downloadURL(completion: { url, error in
                           guard let url = url, error == nil else{
                               return
                           }
                self.user?.photoUrl = url.absoluteString
                self.user?.photoPath = userId + "/ProfilePhoto/"+"ProfilePhoto"+"\(timestamp)"+".png"
                self.updateUser()
                    })
        })
    }
    
    
     func updateUserCoreData() {
         let id = user?.userid ?? ""
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
         let context = appDelegate.persistentContainer.viewContext
         let fetchRequest = NSFetchRequest<User>(entityName: "User")
         fetchRequest.predicate = NSPredicate(format: "userid == %@", String(id))
         do{
             let result = try context.fetch(fetchRequest)
             if result.isEmpty == false {
                 guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context) else { return }
                 guard let userCore = NSManagedObject(entity: entity, insertInto: context) as? User else { return }
                 userCore.photoUrl = user?.photoUrl
                 userCore.photoPath = user?.photoPath
                 try context.save()
                 updated = true
             }
         }catch(let error){
             print ("error", error)
         }
     }
    
    
    
    func updateUser (){
        let userRef = db.collection("Users").document(user?.userid ?? "")
        userRef.updateData(["name": user?.name ?? "" , "email": user?.email ?? "", "photoPath": user?.photoPath ?? ""]) { (error) in
                   if error == nil {
                       self.updateUserCoreData()
                   }else{
                       print("not updated")
                   }
               }
    }
    
    func changePassword(_ email: String, _ password : String, _ newPassword: String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if  error == nil {
                Auth.auth().currentUser?.updatePassword(to: newPassword)

            }
        }
    }
    
}
