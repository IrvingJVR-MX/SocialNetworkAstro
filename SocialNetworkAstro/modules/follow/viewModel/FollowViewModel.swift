import Foundation
import UIKit
import CoreData

public class FollowViewModel {
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
        FirebaseManager.shared.listenCollectionChanges(type: UserF.self, collection: .Users, completion: { result in
                switch result {
                case .success(let usersFetched):
                    self.users = usersFetched
                    self.getUserInfo()
                case .failure(_):
                    print("error")
                }
        })
                                                
    }
    
    func addFollow(_ index: Int){
        let user = userFollowedDetail(id: usersToFollow[index].id, name: usersToFollow[index].name, profilePhotoUrl: usersToFollow[index].photoUrl)
        FirebaseManager.shared.addFollow(document: user, userId: userObject?.userid ?? "", followedId: user.id, collection: .Users, completion:{ result in
            switch result {
            case .success(_):
                print("Success")
            case .failure(_):
                print("Failed")
            }
        })
    }
        
    func unFollow(_ index: Int){
        let userId = userObject?.userid ?? ""
        let followedId = usersFollowed[index].id
        FirebaseManager.shared.removeFollow(userId: userId, followedId: followedId, collection: .Users, completion: { result in
            switch result {
            case .success(_):
                print("Success")
            case .failure(_):
                print("Failed")
            }
        })
    }
    
    
    func fecthUserFollowedByUser(){
        let userId =  userObject?.userid ?? ""
        FirebaseManager.shared.listenCollectionOfFriends(type: userFollowedDetail.self, userId: userId, collection: .Users, completion: { result in
            switch result {
            case .success(let usersFollowedResult):
                self.usersFollowed =  usersFollowedResult
                self.orderUserYouMayKnow()
            case .failure(_):
                print("error")
            }
            
        })
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
        self.fecthUserFollowedByUser()
       }
    
}

