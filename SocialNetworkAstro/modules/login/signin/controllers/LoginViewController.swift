import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {

    let login = Login ()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    let firebaseManager = FirebaseManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        login.authLogin = { [weak self] () in
            self?.authenticationFinished()
        }
    }
    

    @IBAction func signInButtonAction(_ sender: Any) {
        if let email = emailTextField.text , let password = passwordTextField.text , !email.isEmpty, !password.isEmpty {
            login.authUser(email, password)
        } else{
            alert("Alert", "Please enter Email/Password")
        }
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        let SignUpViewController = SignUpViewController()
        show(SignUpViewController, sender: nil)
    }
    
    func authenticationFinished(){
        if !login.userID.isEmpty {
           let vcTabBar = TabBarViewController()
           show(vcTabBar, sender: nil)
        } else{
            alert("Alert", "Login failed please verify password or contact administrator of the system")
        }
    }
    
    
    func alert (_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
