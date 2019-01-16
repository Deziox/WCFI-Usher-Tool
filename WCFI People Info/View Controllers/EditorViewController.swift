//
//  EditorViewController.swift
//  WCFI People Info
//
//  Created by DeZiox on 1/15/19.
//  Copyright © 2019 DeZiox. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {

    var firstName:String = ""
    var lastName:String = ""
    var email:String = ""
    var birthday:String = ""
    var bibleStudy:String = ""
    var indexId:String = ""
    
    //MARK: Text fields
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var birthdayText: UITextField!
    @IBOutlet weak var bibleStudyText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        firstNameText.text = firstName
        lastNameText.text = lastName
        emailText.text = email
        birthdayText.text = birthday
        bibleStudyText.text = bibleStudy
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "backEditAddSegue", sender: nil)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
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
