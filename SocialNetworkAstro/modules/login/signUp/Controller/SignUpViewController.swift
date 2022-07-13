import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    let register = Register()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register.register = { [weak self] () in
            if self?.register.registerUser == true {
                let alert = UIAlertController(title: "Successful", message: "User registered successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self?.signUpSuccessful()
                }))
                self?.present(alert, animated: true, completion: nil)
            }else{
                self?.alert("Alert", "Failed to register, contact system administrator")
            }
            
        }
    }

    @IBAction func sendRegistrationForm(_ sender: Any) {
      
        if let email = emailTextField.text , let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text ,
           let username = usernameTextField.text, !email.isEmpty , !password.isEmpty, !confirmPassword.isEmpty, !username.isEmpty {
            if password != confirmPassword {
                alert("Alert", "Password dosen´t match")
                passwordTextField.text = ""
                confirmPasswordTextField.text = ""
            }else {
                register.registerUser(email, password, username)
            }
        }else{
            alert("Alert","Please fill all the fields")
        }
    }
    
    func signUpSuccessful(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func alert (_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
