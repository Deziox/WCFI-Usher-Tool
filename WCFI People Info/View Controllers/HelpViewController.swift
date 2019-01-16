//
//  HelpViewController.swift
//  WCFI People Info
//
//  Created by DeZiox on 1/16/19.
//  Copyright © 2019 DeZiox. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    var helpScreen:Int = -1
    
    @IBOutlet weak var tutorialText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        switch(helpScreen){
        case 0:
            tutorialText.text = "Here you can search for a specific church member and their information.\n\nPress the \"Search by\" button to change the search parameters\n\nAll search results will be sorted by last name\n\nTo search for a member with a birthday on a specific month, change the search parameters to birthday and put the number month in the text field \n(01 = Jan,02 = Feb,etc.)."
        default:
            tutorialText.text = "whoa how'd you get here?\nyou have found a glitch in the system\ncongrats..."
        }
    }
    
    @IBAction func backHelpButton(_ sender: UIButton) {
        switch(helpScreen){
        case 0:
            performSegue(withIdentifier: "backHelpLookupSegue", sender: nil)
        default:
            print("another glitch lol")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
