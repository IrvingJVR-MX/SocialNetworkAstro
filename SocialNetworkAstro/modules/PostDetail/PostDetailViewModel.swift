import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
public class PostDetailViewModel {
    var db = Firestore.firestore()
    var post = [PostDetailF]()
    var notifyFetchedPost = { () -> () in}
    var fetched : Bool = false {
        didSet {
            notifyFetchedPost()
        }
    }
    func fecthData(){
        db.collection("PostComments").document("ea").collection("comments").addSnapshotListener{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                return
            }
            self.post = documents.compactMap{ (QueryDocumentSnapshot) -> PostDetailF? in
                return try? QueryDocumentSnapshot.data(as: PostDetailF.self)
            }
            self.fetched = true
        }
        
    }
    
    
}
