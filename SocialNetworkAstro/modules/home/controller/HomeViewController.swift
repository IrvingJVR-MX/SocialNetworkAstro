import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
class HomeViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let homeViewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let uniNib =  UINib(nibName: "HomeTableViewCell", bundle: nil)
        tableView.register(uniNib, forCellReuseIdentifier: "HomeTableViewCell")
        homeViewModel.fecthData()
        homeViewModel.notifyFetchedPost = { [weak self] () in
            if self?.homeViewModel.fetched == true {
                self?.tableView.reloadData()
            }
        }
    }

}


extension HomeViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell ?? HomeTableViewCell(style: .subtitle, reuseIdentifier: "HomeTableViewCell")
        cell.titleLabel.text = homeViewModel.post[indexPath.row].title
        cell.descriptionLabel.text = homeViewModel.post[indexPath.row].description
        if let url = URL (string: homeViewModel.post[indexPath.row].photoURL ?? "" ){
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
