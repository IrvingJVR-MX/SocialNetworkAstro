import Foundation

public class EditPostViewModel {
    var notifyPostPosted = { () -> () in}
    var posted : Bool = false {
        didSet {
            notifyPostPosted ()
        }
    }
    var imageData: Data?
    var userID: String =  ""
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
        FirebaseStorageManager.shared.removePhoto(route: photoPath, completion: { result in
            switch result {
            case true:
                self.savePostPhoto()
            case false:
                print("Failed")
            }
        })
        
    }
        
 
    func savePostPhoto(){
         guard let imageDataStorage = imageData else{ return }
         let timestamp = NSDate().timeIntervalSince1970
         let route = userID + "/PhotoOfPublicacions/\(self.postId)/"+postId+"\(timestamp)"+".png"
         FirebaseStorageManager.shared.uploadPhoto(imageData: imageDataStorage, route: route, completion: { result in
            switch result {
            case .success(let url):
                self.updatePost(self.postTitle, self.postDescription, self.postId, url, route)
            case .failure(_):
                print("Failed")
            }
        })
     }
    
    func updatePost (_ title:String, _ description:String, _ postId: String, _ postPhotoUrl: String, _ photoPath: String) {
        FirebaseManager.shared.updatePost(title: title, description: description, postId: postId, postPhotoUrl: postPhotoUrl, photoPath: photoPath, collection: .Post, completion: { result in
            switch result {
            case true:
                print("updated")
            case false:
                print("not updated")
            }
            
        })
    }
    
    
}

