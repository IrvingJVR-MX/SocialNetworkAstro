import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit
import CoreData
var userObject: User?

public class PostDetailViewModel {
    var db = Firestore.firestore()
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
        db.collection("PostComments").document(id).collection("comments").addSnapshotListener{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                return
            }
            self.post = documents.compactMap{ (QueryDocumentSnapshot) -> PostDetailF? in
                return try? QueryDocumentSnapshot.data(as: PostDetailF.self)
            }
            self.fetched = true
            self.getUserInfo()
        }
        
    }
    
    func createComment (_ id : String, _ comment : String){
        let postComment = PostDetailF(profilePhotoUrl: userObject?.photoUrl ?? "",  profileName: userObject?.name ?? "", comment: comment)
        db.collection("PostComments").document(id).collection("comments").document().setData(postComment.dictionary, completion: { error in
            if error == nil{
                self.postComment = true
            } else{
                self.postComment =  false
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
