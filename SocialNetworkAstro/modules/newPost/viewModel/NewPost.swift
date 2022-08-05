import Foundation
import UIKit
import CoreData

public class NewPost {
    var notifyPostPosted = { () -> () in}
    var posted : Bool = false {
        didSet {
            notifyPostPosted ()
        }
    }
    var imageData: Data?
    var userObject: User?
    var userID: String =  ""
    var imageURL: String = ""
    var postId: String = ""
 
    func addEmptyPost(_ title:String, _ description:String){
        FirebaseManager.shared.addEmptyDocument(collection: .Post, completion: { result in
            if result == "" {
                print("Failed")
            }
            else{
                self.postId = result
                self.savePhoto(title, description)
            }
        })
    }
    
    func savePhoto(_ title:String, _ description:String){
        guard let imageDataStorage = imageData else{ return }
        let timestamp = NSDate().timeIntervalSince1970
        let route = userID + "/PhotoOfPublicacions/\(postId)/"+postId+"\(timestamp)"+".png"
        FirebaseStorageManager.shared.uploadPhoto(imageData: imageDataStorage, route: route, completion: { result in
            switch result {
            case .success(let url):
                self.createPost(title, description, url, route)
            case .failure(_):
                print("Failed")
            }
        })
    }
    
    
    
    func createPost (_ title:String, _ description:String, _ photoURL:String, _ photoPath: String) {
        let timestamp = NSDate().timeIntervalSince1970
        let post = PostF(id: postId , postId: postId,postTitle: title,  profileName: userObject?.name ?? "", profilePhotoUrl: userObject?.photoUrl ?? "" , description: description, userID: userObject?.userid ?? "" , photoURL: photoURL , CountLikes: 0, CreatedAt: timestamp, photoPath: photoPath)
        
        FirebaseManager.shared.addDocument(document: post, collection: .Post, completion: { result in
            switch result {
            case .success(_):
                self.posted = true
            case .failure(_):
                print("error")
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
                 userID =  userObject?.userid ?? ""
             }
         }catch(let error){
             print ("error", error)
         }
       }
    
    
}

