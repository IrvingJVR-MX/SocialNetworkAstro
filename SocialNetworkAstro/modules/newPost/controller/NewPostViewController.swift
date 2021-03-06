import UIKit
import FirebaseStorage
import SwiftUI
class NewPostViewController: UIViewController {

    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var imageViewer: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    let newPost = NewPost()
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isScrollEnabled = false
        newPost.getUserId()
        newPost.notifyPostPosted = { [weak self] () in
            if self?.newPost.posted == true {
                let alert = UIAlertController(title: "Successful", message: "Posted correctly", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self?.textView.text = ""
                    self?.titleTextField.text = ""
                    self?.imageViewer.image = nil
                    self?.tabBarController?.selectedIndex = 0
                }))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    
    }
    @IBAction func addPhotoClicked(_ sender: Any) {
        let vc = UIImagePickerController ()
         vc.sourceType = .photoLibrary
         vc.delegate  = self
         vc.allowsEditing =  true
         present (vc, animated: true)
    }
    
    @IBAction func addPost(_ sender: Any) {
        let title = titleTextField.text ?? ""
        let description = textView.text ?? ""
        newPost.savePhoto(title, description)
    }
    
    @IBAction func discardPost(_ sender: Any) {
        textView.text = ""
        imageViewer.image = nil
        self.tabBarController?.selectedIndex = 0
    }
    

}

extension NewPostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imageViewer.image = image
            newPost.imageData = image.pngData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
