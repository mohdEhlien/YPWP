//
//  HomeViewController.swift
//  YPWP
//
//  Created by Mohamed Mohamed on 2015-10-28.
//  Copyright © 2015 Mohamed Mohamed. All rights reserved.
//

import UIKit
import Parse
import Bolts

class HomeViewController: UIViewController {

	@IBOutlet weak var usernameTF: UITextField!
	@IBOutlet weak var passwordTF: UITextField!
	
	@IBAction func logInButton(sender: AnyObject) {
		self.view.endEditing(true)
		
		PFUser.logInWithUsernameInBackground(usernameTF.text!.lowercaseString, password: passwordTF.text!.lowercaseString) {
			(user: PFUser?, error: NSError?) -> Void in
			if user != nil {
				// Do stuff after successful login.
				self.performSegueWithIdentifier("showMainMenu", sender: self)
			} else {
				// The login failed. Check error to see why.
				self.alert("Sorry!", textMessage: "Looks like you misspelled something, try it again...")
			}
		}
		
	}
	
	override func viewDidAppear(animated: Bool) {
		if PFUser.currentUser() != nil {
			self.performSegueWithIdentifier("autoLogin", sender: self)
		}
	}
	
    override func viewDidLoad() {
		super.viewDidLoad()
        // Do any additional setup after loading the view.
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.view.endEditing(false)
	}
	
	override func viewWillAppear(animated: Bool) {
		self.navigationController!.navigationBar.hidden = true
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
	}
	
	func alert(textTitle: String, textMessage: String) {
		let alertController = UIAlertController(title: textTitle, message: textMessage, preferredStyle: .Alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
		self.presentViewController(alertController, animated: true, completion: nil)
	}

}
