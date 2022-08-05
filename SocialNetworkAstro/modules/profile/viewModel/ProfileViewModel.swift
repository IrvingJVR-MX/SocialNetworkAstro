import Foundation
import UIKit
import CoreData

public class ProfileViewModel {
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
        let userId = userObject?.userid ?? ""
        FirebaseManager.shared.listenMyPostCollectionChanges(type: PostF.self, userId: userId, collection: .Post, completion: { result in
            switch result {
            case .success(let postsFetched):
                self.post = postsFetched
                self.fetched = true
            case .failure(_):
                self.fetched = false
            }
        })
    }
    
    func deletePost(_ index: Int){
        let postId = post[index].postId
        FirebaseManager.shared.removeDocument(documentID: postId, collection: .Post, completion: { result in
            switch result {
            case .success(_):
                print("Deleted!")
            case .failure(_):
                print("Failed")
            }
        })
    }
    
    
    func deletePostImage(_ index: Int){
         let route = post[index].photoPath
        FirebaseStorageManager.shared.removePhoto(route: route, completion: { result in
            switch result {
            case true:
                self.deletePost(index)
            case false:
                print("Failed")
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
