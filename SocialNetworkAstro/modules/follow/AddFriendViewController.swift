import UIKit
import Kingfisher
class AddFriendViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var addFriendViewModel = AddFriendViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let uniNib =  UINib(nibName: "FriendTableViewCell", bundle: nil)
        tableView.register(uniNib, forCellReuseIdentifier: "FriendTableViewCell")
        addFriendViewModel.fecthUsersArray()
        addFriendViewModel.notifyFetchedPost = { [weak self] () in
            if self?.addFriendViewModel.fetched == true {
                self?.tableView.reloadData()
            }
        }
    }

    @IBAction func segmentedChanged(_ sender: Any) {
        tableView.reloadData()
    }
    
    @objc func followUser(sender: UIButton) {
        let index = sender.tag
        addFriendViewModel.addFollow(index)
    }
    
    @objc func unFollowUser(sender: UIButton) {
        let index = sender.tag
        addFriendViewModel.unFollow(index)
    }
}


extension AddFriendViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0 :
            return addFriendViewModel.usersToFollow.count
        case 1:
            return addFriendViewModel.usersFollowed.count
        default:
            break
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell") as? FriendTableViewCell ?? FriendTableViewCell (style: .subtitle, reuseIdentifier: "FriendTableViewCell")
        switch segmentedControl.selectedSegmentIndex {
        case 0 :
            if let url = URL (string: addFriendViewModel.usersToFollow[indexPath.row].photoUrl){
                cell.profileImageView.kf.setImage(with: url)
            }
            cell.profileNameLabel.text = addFriendViewModel.usersToFollow[indexPath.row].name
            cell.followButton.setTitle("Follow", for: .normal)
            cell.messageButton.isHidden = true
            cell.followButton.removeTarget(self, action: #selector(unFollowUser(sender:)), for: .touchUpInside)
            cell.followButton.addTarget(self, action: #selector(followUser(sender:)), for: .touchUpInside)
            cell.followButton.tag = indexPath.row
            
        case 1:
            if let url = URL (string: addFriendViewModel.usersFollowed[indexPath.row].profilePhotoUrl){
                cell.profileImageView.kf.setImage(with: url)
                }
                cell.profileNameLabel.text = addFriendViewModel.usersFollowed[indexPath.row].name
                cell.followButton.setTitle("un Follow", for: .normal)
                cell.followButton.removeTarget(self, action: #selector(followUser(sender:)), for: .touchUpInside)
                cell.followButton.addTarget(self, action: #selector(unFollowUser(sender:)), for: .touchUpInside)
                cell.followButton.tag = indexPath.row
        default:
            break
        }
        return cell
    }
}