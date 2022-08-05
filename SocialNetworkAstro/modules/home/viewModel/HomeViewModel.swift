import Foundation
public class HomeViewModel {
    var post = [PostF]()
    var originalPostList =  [PostF]()
    var notifyFetchedPost = { () -> () in}
    var fetched : Bool = false {
        didSet {
            notifyFetchedPost()
        }
    }
    
    
    func fecthData(){
        FirebaseManager.shared.listenCollectionChanges(type: PostF.self, collection: .Post, completion: { result in
            switch result {
            case .success(let posts):
                self.post = posts
                self.originalPostList = posts
                self.fetched = true
            case .failure(_):
                self.fetched = false
            }
        })
     }
    
    
    func filterPost(_ title :String){
        post = post.filter({$0.postTitle.lowercased().contains(title.lowercased())})
    }
    
}
