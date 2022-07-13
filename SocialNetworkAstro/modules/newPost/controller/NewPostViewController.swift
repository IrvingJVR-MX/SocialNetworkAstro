import UIKit

class NewPostViewController: UIViewController {

    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var imageViewer: UIImageView!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isScrollEnabled = false

    }
    
    
    @IBAction func addPhotoClicked(_ sender: Any) {
        let vc = UIImagePickerController ()
         vc.sourceType = .photoLibrary
         vc.delegate  = self
         vc.allowsEditing =  true
         present (vc, animated: true)
    }
}

extension NewPostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imageViewer.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
