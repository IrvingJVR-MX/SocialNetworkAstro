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
    func fecthData(_ id: String){
        db.collection("PostComments").document(id).collection("comments").addSnapshotListener{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                return
            }
            self.post = documents.compactMap{ (QueryDocumentSnapshot) -> PostDetailF? in
                return try? QueryDocumentSnapshot.data(as: PostDetailF.self)
            }
            self.fetched = true
        }
        
    }
    
    func createComment (_ id : String, _ comment : String){
        let postComment = PostDetailF(profilePhotoUrl: "https://firebasestorage.googleapis.com/v0/b/socialnetworkastro.appspot.com/o/5xaOocGu7ZWqJdmazySqOSxf8lW2%2FProfilePhoto%2Fprofile.jpg?alt=media&token=3e11dd49-e63d-4b7f-bc39-70b2179e80dd", profileName: "Irving", comment: comment)
        
        db.collection("PostComments").document(id).collection("comments").document().setData(postComment.dictionary, completion: { error in
            if error == nil{
                print("se hizo")
            } else{
                print("error")
            
            }
        })
        
        
    }
    
    
}
