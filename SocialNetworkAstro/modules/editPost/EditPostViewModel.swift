import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseCore
import FirebaseDatabase

public class EditPostViewModel {
    var notifyPostPosted = { () -> () in}
    var posted : Bool = false {
        didSet {
            notifyPostPosted ()
        }
    }
    let storage = Storage.storage().reference()
    var imageData: Data?
    var userID: String =  ""
    let db = Firestore.firestore()
    var imageURL: String = ""
    var postPhotoUrl : String = "" 
    var postId : String = ""
    var postDescription: String = ""
    var postTitle : String = ""
    
    
    
    func savePost(_ title:String, _ description:String, _ id: String, _ photoURL : String, _ photoPath : String){
        postPhotoUrl = photoURL
        postTitle = title
        postId = id
        postDescription = description
        if imageData == nil {
            updatePost(title, description, postId, "", "")
        } else{
            deletePostPhoto(photoPath)
        }
    }
    
    func deletePostPhoto (_ photoPath:String) {
        storage.child(photoPath).delete(completion: { error in
            if error == nil {
                self.savePostPhoto()
            }
        })
        
    }
    
    func savePostPhoto(){
        let timestamp = NSDate().timeIntervalSince1970
        guard let imageDataStorage = imageData else{ return }
        storage.child(userID + "/PhotoOfPublicacions/\(self.postId)/"+postId+"\(timestamp)"+".png").putData(imageDataStorage, metadata: nil, completion: { _, error in
            guard error == nil else{
                print("Failed")
                return
            }
            self.storage.child(self.userID + "/PhotoOfPublicacions/\(self.postId)/"+self.postId+"\(timestamp)"+".png").downloadURL(completion: { url, error in
                           guard let url = url, error == nil else{
                               return
                           }
                let path = "\(self.userID)" + "/PhotoOfPublicacions/\(self.postId)/"+"\(self.postId)"+"\(timestamp)"+".png"
                self.updatePost(self.postTitle, self.postDescription, self.postId, url.absoluteString, path)
                    })
        })
    }
    
    func updatePost (_ title:String, _ description:String, _ postId: String, _ postPhotoUrl: String, _ photoPath: String) {
        let userRef = db.collection("Post").document(postId)
        if postPhotoUrl == "" {
            userRef.updateData(["postTitle": title ,"description": description]) { (error) in
                   if error == nil {
                       print("updated")
                   }else{
                       print("not updated")
                   }
               }
        } else{
            userRef.updateData(["postTitle": title ,"description": description, "photoURL": postPhotoUrl, "photoPath": photoPath]) { (error) in
                   if error == nil {
                       print("updated")
                   }else{
                       print("not updated")
                   }
               }
        }
    }
    
    
}

