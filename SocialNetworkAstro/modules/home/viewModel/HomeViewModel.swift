import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
public class HomeViewModel {
    var db = Firestore.firestore()
    var post = [PostF]()
    var notifyFetchedPost = { () -> () in}
    var fetched : Bool = false {
        didSet {
            notifyFetchedPost()
        }
    }
    
    func fecthData(){
        db.collection("Post").addSnapshotListener{ (querySnapshot, error) in
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
}