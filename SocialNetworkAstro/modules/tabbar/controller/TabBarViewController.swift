import UIKit

class TabBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarVC = UITabBarController()
        let vcHome = HomeViewController()
        vcHome.title =  "Home"
        let vcNewPost = NewPostViewController()
        vcNewPost.title = "New Post"
        let vcAddFriends = AddFriendViewController()
        vcAddFriends.title = "Add Friends"
        let vcProfile = ProfileViewController()
        vcProfile.title = "Profile"
        tabBarVC.setViewControllers([vcHome,vcNewPost,vcAddFriends,vcProfile], animated: false)
        guard let items = tabBarVC.tabBar.items else { return }
        let images = ["house", "plus.app.fill","person.fill.badge.plus", "person.fill"]
        for x in 0..<items.count{
            items[x].image = UIImage(systemName: images[x])
        }
        
        
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }

}
