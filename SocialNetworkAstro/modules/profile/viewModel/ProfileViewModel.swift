import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import UIKit
import CoreData

public class ProfileViewModel {
    let storage = Storage.storage().reference()
    var db = Firestore.firestore()
    var post = [PostF]()
    var notifyFetchedPost = { () -> () in}
    var fetched : Bool = false {
        didSet {
            notifyFetchedPost()
        }
    }
    
    var notifyFetchedUserInfo = { () -> () in}
    var fetchedUpdatedUserInfo : Bool = false {
        didSet {
            notifyFetchedUserInfo()
        }
    }
    var userObject: User?
    
    
    
    func fecthData(){
        db.collection("Post").whereField("userID",  isEqualTo: userObject?.userid ?? "").addSnapshotListener{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                self.fetched = false
                return
            }
            self.post = documents.compactMap{ (QueryDocumentSnapshot) -> PostF? in
                return try? QueryDocumentSnapshot.data(as: PostF.self)
            }
            self.fetched = true
        }
    }
    
    func deletePost(_ index: Int){
        db.collection("Post").document(post[index].postId).delete() { error in
            if error == nil{
               print("gooood")
            }
        }
    }
    
    func deletePostImage(_ index: Int){
        storage.child(post[index].photoPath).delete(completion: { error in
            if error == nil{
                self.deletePost(index)
            }
        })
    }
    
    
    func getUserInfo(){
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
         let context = appDelegate.persistentContainer.viewContext
         let fetchRequest = NSFetchRequest<User>(entityName: "User")
         do{
             let dbUser = try context.fetch(fetchRequest)
             if dbUser[0].userid != nil {
                 userObject = dbUser[0]
                 fecthData()
                 
             }
         }catch(let error){
             print ("error", error)
         }
       }
    
    func getUpdatedUserInfo(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        do{
            let dbUser = try context.fetch(fetchRequest)
            if dbUser[0].userid != nil {
                userObject = dbUser[0]
                self.fetchedUpdatedUserInfo = true
            }
        }catch(let error){
            print ("error", error)
        }
    }
    
    func deleteUserInfo(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let user = userObject else {return}
        let context = appDelegate.persistentContainer.viewContext
        context.delete(user)
        try? context.save()
    }
    
    
}
