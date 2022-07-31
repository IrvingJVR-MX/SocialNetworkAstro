import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit
import CoreData

public class AddFriendViewModel {
    var db = Firestore.firestore()
    var users = [UserF]()
    var userObject: User?
    var usersFollowed = [userFollowedDetail]()
    var usersToFollow = [UserF]()
    var notifyFetchedPost = { () -> () in}
    var fetched : Bool = false {
        didSet {
            notifyFetchedPost()
        }
    }
    func fecthUsersArray(){
        db.collection("Users").getDocuments(completion:{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                return
            }
            self.users = documents.compactMap{ (QueryDocumentSnapshot) -> UserF? in
                return try? QueryDocumentSnapshot.data(as: UserF.self)
            }
            self.getUserInfo()
        })
    }
    
    func addFollow(_ index: Int){
        let user = userFollowedDetail(id: usersToFollow[index].id, name: usersToFollow[index].name, profilePhotoUrl: usersToFollow[index].photoUrl)
        db.collection("Users").document(userObject?.userid ?? "").collection("Friends").document(user.id).setData(user.dictionary, completion: { error in
            if error == nil{
                
            } else{
        
            }
        })
    }
    
    
    func unFollow(_ index: Int){
        db.collection("Users").document(userObject?.userid ?? "").collection("Friends").document(usersFollowed[index].id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    
    func fecthUserFollweByUser(){
        db.collection("Users").document(userObject?.userid ?? "").collection("Friends").addSnapshotListener{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                return
            }
            self.usersFollowed = documents.compactMap{ (QueryDocumentSnapshot) -> userFollowedDetail? in
                return try? QueryDocumentSnapshot.data(as: userFollowedDetail.self)
            }
            self.orderUserYouMayKnow()
        }
    }
    
    func orderUserYouMayKnow(){
        usersToFollow = users
        usersFollowed = usersFollowed.filter {$0.id != ""}
        usersToFollow = usersToFollow.filter{$0.id != userObject?.userid}
        for val in usersFollowed{
            usersToFollow = usersToFollow.filter{ $0.id != val.id}
        }
        self.fetched = true
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
        self.fecthUserFollweByUser()
       }
    
}

