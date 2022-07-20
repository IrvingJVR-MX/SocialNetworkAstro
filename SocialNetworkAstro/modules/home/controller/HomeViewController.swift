import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
class HomeViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var db = Firestore.firestore()
    var post = [PostF]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let uniNib =  UINib(nibName: "HomeTableViewCell", bundle: nil)
        tableView.register(uniNib, forCellReuseIdentifier: "HomeTableViewCell")
        fecthData()
    }

}

extension HomeViewController {
    func fecthData(){
        db.collection("Post").addSnapshotListener{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                return
            }
            self.post = documents.compactMap{ (QueryDocumentSnapshot) -> PostF? in
                return try? QueryDocumentSnapshot.data(as: PostF.self)
            }
            self.tableView.reloadData()
        }
    }

}

extension HomeViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell ?? HomeTableViewCell(style: .subtitle, reuseIdentifier: "HomeTableViewCell")
        
        cell.titleLabel.text = post[indexPath.row].title
        cell.descriptionLabel.text = post[indexPath.row].description
        if let url = URL (string: post[indexPath.row].photoURL ?? "" ){
            cell.postImageView.load(url: url)
        }
        return cell
    }
}



extension UIImageView{
    
    func load(url: URL){
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
            
        }
        
    }
}
