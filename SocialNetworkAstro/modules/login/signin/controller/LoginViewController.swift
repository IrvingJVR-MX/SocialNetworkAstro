import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let login = Login ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login.authLogin = { [weak self] () in
            if self?.login.userID != "" {
                self?.authenticationFinished()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        login.checkIfUserIsLoginIn()
        login.authLogin = { [weak self] () in
            self?.authenticationFinished()
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        if let email = emailTextField.text , let password = passwordTextField.text , !email.isEmpty, !password.isEmpty {
            login.authUser(email, password)
        } else{
            alert("Alert", "Please enter Email/Password")
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let SignUpViewController = SignUpViewController()
        show(SignUpViewController, sender: nil)
    }
    
    func authenticationFinished(){
        if !login.userID.isEmpty {
            SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: true)
        }
    }
    
    
    func alert (_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
