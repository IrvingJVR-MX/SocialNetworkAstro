import Foundation
import FirebaseStorage
import UIKit
import CoreData
import FirebaseFirestore

public class NewPost {
    var notifyPostPosted = { () -> () in}
    var posted : Bool = false {
        didSet {
            notifyPostPosted ()
        }
    }
    let storage = Storage.storage().reference()
    var imageData: Data?
    var userID: String =  ""
    let firebaseManager = FirebaseManager.shared
    let db = Firestore.firestore()
    var imageURL: String = ""
    var postId: String = ""
    func savePhoto(_ title:String, _ description:String){
        postId = db.collection("Post").document().documentID
        guard let imageDataStorage = imageData else{ return }
        storage.child(userID + "/PhotoOfPublicacions/"+postId+".png").putData(imageDataStorage, metadata: nil, completion: { _, error in
            guard error == nil else{
                print("Failed")
                return
            }
            self.storage.child(self.userID + "/PhotoOfPublicacions/"+self.postId+".png").downloadURL(completion: { url, error in
                           guard let url = url, error == nil else{
                               return
                           }
                        self.createPost(title, description, url.absoluteString)
                      })
        })
    }
    func createPost (_ title:String, _ description:String, _ photoURL:String) {
        let timestamp = NSDate().timeIntervalSince1970
        let city = PostF(title: title, description: description, userID: userID , photoURL: photoURL , CountLikes: 0, CreatedAt: timestamp)
        db.collection("Post").document(postId).setData(city.dictionary, completion: { error in
            if error == nil{
                self.posted = true
            } else{
                print("error")
            
            }
        })
    }
    
    
    func getUserId(){
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
         let context = appDelegate.persistentContainer.viewContext
         let fetchRequest = NSFetchRequest<User>(entityName: "User")
         do{
             let dbUser = try context.fetch(fetchRequest)
             if let userId = dbUser[0].userid, !userId.isEmpty {
                 self.userID = userId
             }
         }catch(let error){
             print ("error", error)
         }
       }
    
    
}

