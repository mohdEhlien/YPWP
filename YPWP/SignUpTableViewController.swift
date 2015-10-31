import UIKit
import Parse
import Bolts

let newUser = PFUser()

var userFirstname: String = ""
var userLastname: String = ""
var userUsername: String = ""
var userPassword: String = ""
var userEmail: String = ""

class SignUpIntroductionTableViewController: UITableViewController {
	
	@IBOutlet weak var firstnameTF: UITextField!
	@IBOutlet weak var lastnameTF: UITextField!
	
	@IBAction func nextToShowUsernameButton(sender: AnyObject) {
		if firstnameTF.text == "" && lastnameTF.text == "" {
			self.alert("Oops", textMessage: "Looks like you missed out your first and last name...")
		} else if firstnameTF.text == "" {
			self.alert("Oops", textMessage: "Looks like you missed out your last name...")
		} else if lastnameTF.text == "" {
			self.alert("Oops", textMessage: "Looks like you missed out your last name...")
		} else {
			userFirstname = (self.firstnameTF.text?.lowercaseString)!
			userLastname = (self.lastnameTF.text?.lowercaseString)!
			print("Firstname & Lastname Passed = " + userFirstname + " " + userLastname)
		}
		return
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.endEditing(true)
	}
	
	override func viewWillAppear(animated: Bool) {
		self.navigationController!.navigationBar.hidden = false
		self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
		self.navigationController!.navigationBar.shadowImage = UIImage()
		self.navigationController!.navigationBar.translucent = true
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func alert(textTitle: String, textMessage: String) {
		let alertController = UIAlertController(title: textTitle, message: textMessage, preferredStyle: .Alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
		self.presentViewController(alertController, animated: true, completion: nil)
	}
}

class SignUpUsernameTableViewController: UITableViewController {
	
	@IBOutlet weak var usernameTF: UITextField!
	
	@IBAction func nextToShowPasswordButton(sender: AnyObject) {
		if usernameTF.text == "" {
			self.alert("Oops", textMessage: "Looks like you missed out your username")
		} else {
			userUsername = (usernameTF.text?.lowercaseString)!
			print("Username Passed = " + userUsername)
		}
		return
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.endEditing(true)
	}
	
	override func viewWillAppear(animated: Bool) {
		self.navigationController!.navigationBar.hidden = false
		self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
		self.navigationController!.navigationBar.shadowImage = UIImage()
		self.navigationController!.navigationBar.translucent = true
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	func alert(textTitle: String, textMessage: String) {
		let alertController = UIAlertController(title: textTitle, message: textMessage, preferredStyle: .Alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
		self.presentViewController(alertController, animated: true, completion: nil)
	}
}

class SignUpPasswordTableViewController: UITableViewController {
	
	@IBOutlet weak var passwordTF: UITextField!
	
	@IBAction func nextToShowEmailButton(sender: AnyObject) {
		if passwordTF.text == "" {
			self.alert("Oops", textMessage: "Looks like you missed out your password")
		} else {
			userPassword = passwordTF.text!
		}
		return
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.endEditing(true)
	}
	
	override func viewWillAppear(animated: Bool) {
		self.navigationController!.navigationBar.hidden = false
		self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
		self.navigationController!.navigationBar.shadowImage = UIImage()
		self.navigationController!.navigationBar.translucent = true
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	func alert(textTitle: String, textMessage: String) {
		let alertController = UIAlertController(title: textTitle, message: textMessage, preferredStyle: .Alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
		self.presentViewController(alertController, animated: true, completion: nil)
	}
}

class SignUpEmailTableViewController: UITableViewController {
	
	@IBOutlet weak var emailTF: UITextField!
	
	@IBAction func signUpButton(sender: AnyObject) {
		newUser["firstname"] = userFirstname
		newUser["lastname"] = userLastname
		newUser.username = userUsername
		newUser.password = userPassword
		newUser.email = (emailTF.text?.lowercaseString)!
		
		newUser.signUpInBackgroundWithBlock {
			(succeeded: Bool, error: NSError?) -> Void in
			if let _ = error {
				self.alert("Oops", textMessage: "Looks like that account info is already taken, try something new.")
				
			} else {
				self.performSegueWithIdentifier("showMainMenu", sender: self)
				//self.alert("Congratulation!", textMessage: "Success, your account has been created.")
			}
		}

	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.endEditing(true)
	}
	
	override func viewWillAppear(animated: Bool) {
		self.navigationController!.navigationBar.hidden = false
		self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
		self.navigationController!.navigationBar.shadowImage = UIImage()
		self.navigationController!.navigationBar.translucent = true
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func alert(textTitle: String, textMessage: String) {
		let alertController = UIAlertController(title: textTitle, message: textMessage, preferredStyle: .Alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
		self.presentViewController(alertController, animated: true, completion: nil)
	}
}