import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public class AddFriendViewModel {
    var db = Firestore.firestore()
    var users = [UserF]()
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
            self.fecthUserFollweByUser()
        })
    }
    
    func fecthUserFollweByUser(){
        db.collection("Users").document("6YtR4g1q24ZNXgcx2FkvC7nu5wz1").collection("Friends").addSnapshotListener{ (querySnapshot, error) in
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
        for val in usersFollowed{
            usersToFollow = usersToFollow.filter{ $0.id != val.id}
        }
        self.fetched = true
    }
    
}

