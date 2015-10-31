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
	
	let colorWheel = ColorWheel()
	
	var question : String! = ""
	var answer : String! = ""
	var objectIDArray = [String]()
	var randomID = 0
	var rightAnswers = 0
	var wrongAnswers = 0
	var skippedQuestions = 0
	
	@IBAction func skipItButton(sender: AnyObject) {
		//self.alert("Opps!", textMessage: "You just skipped a question. This will not be added to your pool.")
		answerTF.text = ""
		print("Skipped Questions: \(++skippedQuestions)")
		self.questionLabel.alpha = 0
		changeColor()
		callData()
	}
	
	@IBAction func acceptItButton(sender: AnyObject) {
		if ((answerTF.text?.caseInsensitiveCompare(self.answer)) == NSComparisonResult.OrderedSame) {
			answerTF.text = ""
			print("Right Answers: \(++rightAnswers)")
			self.questionLabel.alpha = 0
			changeColor()
			removeAndUpdateQuestion()
		} else if ( answerTF.text == "" ) {
			alert("Empty Field", textMessage: "Looks like you forgot to put the answer. Either press next or skip the question.")
		} else {
			alert("Oh oh.", textMessage: "Sorry that was the wrong answer...")
			answerTF.text = ""
			print("Wrong Answers: \(++wrongAnswers)")
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
		
		// FIND THE OBJECT IDs FOR THE QUESTIONS
		let objectIdQuery : PFQuery = PFQuery(className: "QuestionsAndAnswers")
		objectIdQuery.findObjectsInBackgroundWithBlock {
			(objects : [PFObject]? , error : NSError?) -> Void in
			
			var objectID = objects! as [PFObject]
			for i in 0..<objectID.count {
				self.objectIDArray.append(objectID[i].objectId!)
			}
			self.callData()
		}
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
	
	func getRandomObjectID() {
		// RANDOMIZE THE QUESTIONS USING THE OBJECT ID
		randomID = Int(arc4random_uniform(UInt32(objectIDArray.count)))
	}
	
	func callData() {
		getRandomObjectID()
		if ( objectIDArray.count > 0 ) {
		let query : PFQuery = PFQuery(className: "QuestionsAndAnswers")
		query.getObjectInBackgroundWithId(objectIDArray[randomID]) {
			(object : PFObject? , error : NSError?) -> Void in
			if error == nil {
				self.question = object!["Question"] as! String!
				self.answer = object!["Answer"] as! String!
				self.questionLabel.text = self.question
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
