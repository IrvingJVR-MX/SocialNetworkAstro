import UIKit
import SVProgressHUD
class EditProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    var user: User?
    let editProfileViewModel = EditProfileViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL (string: user?.photoUrl ?? ""){
            imageView.kf.setImage(with: url)
         }
        usernameTextField.text = user?.name
        editProfileViewModel.notifyUpdate = { [weak self] () in
            if self?.editProfileViewModel.updated == true {
                SVProgressHUD.dismiss()
                self?.closeView()
            }
        }
    }

    @IBAction func addPhoto(_ sender: Any) {
        let vc = UIImagePickerController ()
        vc.sourceType = .photoLibrary
        vc.delegate  = self
        present (vc, animated: true)
    }
    
    @IBAction func updateInfo(_ sender: Any) {
        SVProgressHUD.show()
        editProfileViewModel.user = user
        editProfileViewModel.user?.name = usernameTextField.text ?? ""
        editProfileViewModel.updateUserInfo()
       
    }
    func closeView(){
        _ = navigationController?.popViewController(animated: true)
    }
}

extension EditProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                imageView.image = image
                editProfileViewModel.imageData = image.pngData()
            }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
