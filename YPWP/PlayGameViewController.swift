//
//  PlayGameViewController.swift
//  YPWP
//
//  Created by Mohamed Mohamed on 2015-10-29.
//  Copyright © 2015 Mohamed Mohamed. All rights reserved.
//

import UIKit
import Parse
import Bolts

class PlayGameViewController: UIViewController {

	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var answerTF: UITextField!
	@IBOutlet weak var skipItButton: UIButton!
	@IBOutlet weak var answerItButton: UIButton!
	@IBOutlet weak var wrongLabel: UILabel!
	@IBOutlet weak var correctLabel: UILabel!
	@IBOutlet weak var skippedLabel: UILabel!
	@IBOutlet weak var timerLabel: UILabel!
	
	
	let colorWheel = ColorWheel()
	
	var questionQ : String! = ""
	var questionL : String! = ""
	var answer : String! = ""
	var objectIDArray = [String]()
	var randomID = 0
	var rightAnswers = 0
	var wrongAnswers = 0
	var skippedQuestions = 0
	var timer = NSTimer()
	var counter = 20
	
	@IBAction func skipItButton(sender: AnyObject) {
		//self.alert("Opps!", textMessage: "You just skipped a question. This will not be added to your pool.")
		answerTF.text = ""
		counter = 20
		skippedLabel.text = "Skipped: \(++skippedQuestions)"
		self.questionLabel.alpha = 0
		changeColor()
		callData()
	}
	
	@IBAction func acceptItButton(sender: AnyObject) {
		if ((answerTF.text?.caseInsensitiveCompare(self.answer)) == NSComparisonResult.OrderedSame) {
			answerTF.text = ""
			counter = 20
			correctLabel.text = "Correct: \(++rightAnswers)"
			self.questionLabel.alpha = 0
			changeColor()
			removeAndUpdateQuestion()
		} else if ( answerTF.text == "" ) {
			alert("Empty Field", textMessage: "Looks like you forgot to put the answer. Either press next or skip the question.")
		} else {
			alert("Oh oh.", textMessage: "Sorry that was the wrong answer... Don't worry, you'll get another chance at it next time!")
			answerTF.text = ""
			counter = 20
			wrongLabel.text = "Wrong: \(++wrongAnswers)"
			self.questionLabel.alpha = 0
			changeColor()
			callData()
		}
		
	}
	
	@IBAction func closeButton(sender: AnyObject) {
		self.performSegueWithIdentifier("showMainMenu", sender: self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.endEditing(true)
		
		changeColor()
		resetScoresToZero()
		
		self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("startTimer:"), userInfo: nil, repeats: true)
		self.timerLabel.text = "Question will change in: \(counter)s"
		
		let objectIdQuery : PFQuery = PFQuery(className: "GeographyQA")
		objectIdQuery.findObjectsInBackgroundWithBlock {
			(objects : [PFObject]? , error : NSError?) -> Void in
			
			var objectID = objects! as [PFObject]
			
			for i in 0..<objectID.count {
				self.objectIDArray.append(objectID[i].objectId!)
			}
			
			self.callData()
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		self.becomeFirstResponder()
		self.navigationController!.navigationBar.hidden = false
		self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
		self.navigationController!.navigationBar.shadowImage = UIImage()
		self.navigationController!.navigationBar.translucent = true
		self.navigationItem.setHidesBackButton(true, animated:true)
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
	}
	
	func getRandomObjectID() {
		randomID = Int(arc4random_uniform(UInt32(objectIDArray.count)))
	}
	
	func callData() {
		getRandomObjectID()
		if ( objectIDArray.count > 0 ) {
		let query : PFQuery = PFQuery(className: "GeographyQA")
		query.getObjectInBackgroundWithId(objectIDArray[randomID]) {
			(object : PFObject? , error : NSError?) -> Void in
			if error == nil {
				self.questionQ = object!["QuestionQ"] as! String!
				self.questionL = object!["QuestionL"] as! String!
				self.answer = object!["Answer"] as! String!
				self.questionLabel.text = self.questionQ + " " + self.questionL
				self.questionLabel.alpha = 0
				UIView.animateWithDuration(1.0, animations: {
					self.questionLabel.alpha = 1
				})
				
			} else {
				print(error)
			}
		}
		} else {
			self.performSegueWithIdentifier("showMainMenu", sender: self)
			alert("Congrats!", textMessage: "You have completed all the questions, more questions coming soon.")
		}
	}
	
	func removeAndUpdateQuestion() {
		if objectIDArray.count > 0 {
			objectIDArray.removeAtIndex(randomID)
			callData()
		}
	}
	
	func changeColor() {
		let randomColor = colorWheel.randomColor()
		self.view.backgroundColor = randomColor
		self.skipItButton.setTitleColor(randomColor, forState: UIControlState.Normal)
		self.answerItButton.setTitleColor(randomColor, forState: UIControlState.Normal)
	}
	
	func alert(textTitle: String, textMessage: String) {
		let alertController = UIAlertController(title: textTitle, message: textMessage, preferredStyle: .Alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	func resetScoresToZero() {
		skippedLabel.text = "Skipped: 0"
		correctLabel.text = "Correct: 0"
		wrongLabel.text = "Wrong: 0"
	}
	
	func startTimer(timer: NSTimer) {
		
		self.timerLabel.text = "Question will change in: \(counter--)s"
		if counter == -1 {
			skippedLabel.text = "Skipped: \(++skippedQuestions)"
			counter = 20
			callData()
		}
	}
	

}
