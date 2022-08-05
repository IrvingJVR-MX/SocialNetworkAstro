import Foundation
import UIKit
import CoreData
var userObject: User?

public class PostDetailViewModel {
    var post = [PostDetailF]()
    var notifyFetchedPost = { () -> () in}
    var fetched : Bool = false {
        didSet {
            notifyFetchedPost()
        }
    }
    var notifPostComment = { () -> () in}
    var postComment : Bool = false {
        didSet {
            notifyFetchedPost()
        }
    }
  

    func fecthData(_ id: String){
        FirebaseManager.shared.listenCollectionCommentsChanges(type: PostDetailF.self, postId: id, collection: .PostComments, completion: { result in
            switch result {
            case .success(let posts):
                self.post = posts
                self.getUserInfo()
                self.fetched = true
            case .failure(_):
                self.fetched = false
            }
        })
        
    }
 
    func createComment (_ id : String, _ comment : String){
        let postComment = PostDetailF(id: id , profilePhotoUrl: userObject?.photoUrl ?? "",  profileName: userObject?.name ?? "", comment: comment)
        FirebaseManager.shared.addCommentToPost(document: postComment, postId: id, collection: .PostComments, completion: { result in
            switch result {
            case .success(_):
                self.postComment = true
            case .failure(_):
                self.postComment = false
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
             }
         }catch(let error){
             print ("error", error)
         }
       }
    
    
    
    
}
