import UIKit
class EditProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    var user: User?
    let editProfileViewModel = EditProfileViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL (string: user?.photoUrl ?? ""){
            imageView.kf.setImage(with: url)
         }
        usernameTextField.text = user?.name
        emailTextField.text = user?.email
        editProfileViewModel.notifyUpdate = { [weak self] () in
            if self?.editProfileViewModel.updated == true {
                self?.dismiss(animated: true)
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
        editProfileViewModel.user = user
        editProfileViewModel.user?.name = usernameTextField.text ?? ""
        editProfileViewModel.user?.email = emailTextField.text ?? ""
        editProfileViewModel.updateUserInfo()
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
