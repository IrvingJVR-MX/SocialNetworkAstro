import UIKit

class HomeViewController: UIViewController {

    
    let firebaseManager = FirebaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    @IBAction func button(_ sender: Any) {
        //let user = User(id: "skmFSdyTBsgt4TvxY9tkltUH5nA2", name: "UserOne", age: 21, email: "tes@test.com")
        /*
        firebaseManager.addDocument(document: user, collection: .Users) { result in
            switch result {
            case .success(let user):
                print("Success", user)
            case .failure(let error):
                print("Error", error)
            }
        }
        */
    }
    
}
