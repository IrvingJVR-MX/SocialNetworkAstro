import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let profileViewModel = ProfileViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let uniNib =  UINib(nibName: "ProfilePostTableViewCell", bundle: nil)
        tableView.register(uniNib, forCellReuseIdentifier: "ProfilePostTableViewCell")
        profileViewModel.getUserInfo()
        profileViewModel.notifyFetchedPost = { [weak self] () in
            if self?.profileViewModel.fetched == true {
               self?.tableView.reloadData()
                if let url = URL (string: self?.profileViewModel.userObject?.photoUrl ?? ""){
                    self?.profileImageView.kf.setImage(with: url)
               }
                self?.profileNameLabel.text =  self?.profileViewModel.userObject?.name ?? ""
                
            }
        }
    }

    @IBAction func editProfileButton(_ sender: Any) {
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        //profileViewModel.deleteUserInfo()
        self.navigationController?.popViewController(animated: true)

      /*  self.dismiss(animated: false)
        guard   let controllerC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as?
        LoginViewController else{ return }
        self.present(controllerC, animated: true, completion: nil)*/
    }
    
    
    
    @objc func commentPost(sender: UIButton) {
        let index = sender.tag
        let postDetailView = PostDetailViewController()
        postDetailView.post = profileViewModel.post[index]
        show(postDetailView, sender: nil)
    }
    
    @objc func deletePost(sender: UIButton) {
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete the post?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in }))
    
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
            let index = sender.tag
            self.profileViewModel.deletePostImage(index)
        }))
        
        self.present(alert, animated: true, completion: nil)


    }
    
    
}


extension ProfileViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileViewModel.post.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePostTableViewCell") as? ProfilePostTableViewCell ?? ProfilePostTableViewCell(style: .subtitle, reuseIdentifier: "ProfilePostTableViewCell")
        cell.postNameLabel.text = profileViewModel.post[indexPath.row].postTitle
        if let url = URL (string: profileViewModel.post[indexPath.row].photoURL){
            cell.postImageView.kf.setImage(with: url)
       }
        cell.postDescriptionTextView.text = profileViewModel.post[indexPath.row].description
        cell.commentButton.addTarget(self, action: #selector(commentPost(sender:)), for: .touchUpInside)
        cell.commentButton.tag = indexPath.row
        cell.deletePostButton.addTarget(self, action: #selector(deletePost(sender:)), for: .touchUpInside)
        cell.deletePostButton.tag = indexPath.row

        return cell
    }
}
