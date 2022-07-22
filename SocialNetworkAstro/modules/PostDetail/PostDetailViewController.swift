import UIKit
class PostDetailViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    var postDetailViewModel = PostDetailViewModel()
    var post: PostF?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let uniNib =  UINib(nibName: "PostDetailTableViewCell", bundle: nil)
        tableView.register(uniNib, forCellReuseIdentifier: "PostDetailTableViewCell")
        if let url = URL (string: post?.photoURL ?? "" ){
            postImageView.load(url: url)
        }
        descriptionLabel.text = post?.description
        
        postDetailViewModel.fecthData()
        postDetailViewModel.notifyFetchedPost = { [weak self] () in
            if self?.postDetailViewModel.fetched == true {
                self?.tableView.reloadData()
            }
        }
    }

}

extension PostDetailViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDetailViewModel.post.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCell") as? PostDetailTableViewCell ?? PostDetailTableViewCell (style: .subtitle, reuseIdentifier: "PostDetailTableViewCell")
        cell.label.text = postDetailViewModel.post[indexPath.row].one
        return cell
    }
}
