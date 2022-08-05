import UIKit
import FirebaseStorage
import SwiftUI
class NewPostViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    let newPost = NewPost()
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isScrollEnabled = false
        newPost.getUserInfo()
        textView.delegate = self
        newPost.notifyPostPosted = { [weak self] () in
            if self?.newPost.posted == true {
                let alert = UIAlertController(title: "Successful", message: "Posted correctly", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self?.textView.text = ""
                    self?.titleTextField.text = ""
                    self?.imageView.image = nil
                    self?.tabBarController?.selectedIndex = 0
                }))
                self?.present(alert, animated: true, completion: nil)
            }
        }
        textView.text = "Please Add Text ..."
        textView.textColor = UIColor.lightGray
        textView.layer.cornerRadius = 8;
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        imageView.layer.borderColor =  UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 0.5

    
    }
    
    
    
    @IBAction func addPhotoClicked(_ sender: Any) {
         let vc = UIImagePickerController ()
         vc.sourceType = .photoLibrary
         vc.delegate  = self
         present (vc, animated: true)
    }
    
    @IBAction func addPost(_ sender: Any) {
        let title = titleTextField.text ?? ""
        let description = textView.text ?? ""
        newPost.addEmptyPost(title, description)
    }
    
    @IBAction func discardPost(_ sender: Any) {
        textView.text = ""
        titleTextField.text = ""
        imageView.image = nil
        self.tabBarController?.selectedIndex = 0
    }
    

}

extension NewPostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please Add Text ..."
            textView.textColor = UIColor.lightGray
        }
    }

}

extension NewPostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                imageView.image = image
                newPost.imageData = image.pngData()
            }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
