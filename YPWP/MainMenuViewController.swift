//
//  MainMenuViewController.swift
//  YPWP
//
//  Created by Mohamed Mohamed on 2015-10-28.
//  Copyright © 2015 Mohamed Mohamed. All rights reserved.
//

import UIKit
import Parse
import Bolts

class MainMenuViewController: UIViewController {
	
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var editProfileButton: UIButton!
	@IBOutlet weak var settingsButton: UIButton!
	
	
	let colorWheel = ColorWheel()

	@IBAction func signOutButton(sender: AnyObject) {
		PFUser.logOut()
		self.performSegueWithIdentifier("showLogIn", sender: self)
	}
	
	override func viewDidLoad() {
		let randomColor = colorWheel.randomColor()
		super.viewDidLoad()
		self.view.backgroundColor = randomColor
		self.playButton.setTitleColor(randomColor, forState: UIControlState.Normal)
		self.editProfileButton.setTitleColor(randomColor, forState: UIControlState.Normal)
		self.settingsButton.setTitleColor(randomColor, forState: UIControlState.Normal)
        // Do any additional setup after loading the view.
	}
	
	override func viewWillAppear(animated: Bool) {
		self.navigationController!.navigationBar.hidden = false
		self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
		self.navigationController!.navigationBar.shadowImage = UIImage()
		self.navigationController!.navigationBar.translucent = true
		self.navigationItem.setHidesBackButton(true, animated:true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
}
