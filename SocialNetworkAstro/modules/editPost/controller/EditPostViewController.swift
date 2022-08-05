import UIKit
import SVProgressHUD
class EditPostViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var textView: UITextView!
    var post: PostF?
    let editPostViewModel = EditPostViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = post?.description
        titleLabel.text = post?.postTitle
        if let url = URL (string: post?.photoURL ?? ""){
            imageView.kf.setImage(with: url)
        }
        editPostViewModel.userID = post?.userID ?? ""
        editPostViewModel.notifyPostPosted = { [weak self] () in
            if self?.editPostViewModel.posted == true {
                SVProgressHUD.dismiss()
                self?.closeView()
            }
            
        }
    }

    @IBAction func addPhotoButton(_ sender: Any) {
        let vc = UIImagePickerController ()
        vc.sourceType = .photoLibrary
        vc.delegate  = self
        present (vc, animated: true)
    }
    
    @IBAction func updateButton(_ sender: Any) {
        SVProgressHUD.show()
        let title = titleLabel.text ?? ""
        let description = textView.text ?? ""
        editPostViewModel.savePost(title, description, post?.postId ?? "", post?.photoURL ?? "", post?.photoPath ?? "")
        
    }
    func closeView(){
        _ = navigationController?.popViewController(animated: true)
    }
    
}

extension EditPostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                imageView.image = image
                editPostViewModel.imageData = image.pngData()
            }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
