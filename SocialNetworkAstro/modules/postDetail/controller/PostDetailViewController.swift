import UIKit
import Kingfisher
class PostDetailViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var descriptionTexView: UITextView!
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
            postImageView.kf.setImage(with: url)
        }
        descriptionTexView.text = post?.description
        
        postDetailViewModel.fecthData(post?.postId ?? "")
        postDetailViewModel.notifyFetchedPost = { [weak self] () in
            if self?.postDetailViewModel.fetched == true {
                self?.tableView.reloadData()
            }
        }
        
        postDetailViewModel.notifPostComment = { [weak self] () in
            if self?.postDetailViewModel.postComment == false {
                self?.alertPopUp("Alert", "Failed to post comment")
            }
        }
        
    }

    @IBAction func sendComment(_ sender: Any) {
        if let comment = commentTextField.text, comment.isEmpty == false {
            postDetailViewModel.createComment(post?.postId ?? "", comment)
            commentTextField.text =  ""
        }
    }
    
    func alertPopUp(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension PostDetailViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDetailViewModel.post.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCell") as? PostDetailTableViewCell ?? PostDetailTableViewCell (style: .subtitle, reuseIdentifier: "PostDetailTableViewCell")
        if let url = URL (string: postDetailViewModel.post[indexPath.row].profilePhotoUrl){
            cell.profileImageView.kf.setImage(with: url)
        }
        cell.profileNameLabel.text = postDetailViewModel.post[indexPath.row].profileName
        cell.commentLabel.text = postDetailViewModel.post[indexPath.row].comment
        return cell
    }
}
