//
//  GuestSignInViewController.swift
//  WCFI People Info
//
//  Created by DeZiox on 1/18/19.
//  Copyright © 2019 DeZiox. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class GuestSignInViewController: UIViewController, UITextFieldDelegate{

    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    var sections:[String] = []
    var members:[String:[String]] = [:]
    var finalMembers:[(String,[String])] = []
    var numberOfMembers : Int = 0
    let db = Firestore.firestore()
    let util = UTUtilities()
    var attendance:[String:Bool] = [:]
    var attendanceData:[String:Bool] = [:]
    var date:(String,String) = ("","")
    
    var indexLength:Int = 0
    var indexId:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        firstNameText.delegate = self
        lastNameText.delegate = self
        emailText.delegate = self
        
        db.collection("Metadata").document("metadata").getDocument { (document, error) in
            print("test")
            if let document = document, document.exists {
                let dataDescription:Int = Int(document.data()?["length"] as! String)!
                self.indexLength = dataDescription
            } else {
                print("Document does not exist")
            }
        }
        db.collection("Metadata").document("guestMetadata").getDocument{
            (document, error) in
            print("test")
            if let document = document, document.exists {
                let dataDescription:Int = Int(document.data()?["length"] as! String)!
                self.indexId = dataDescription
            } else {
                print("Document does not exist")
            }
        }
        
        reset()
    }
    
    func reset(){
        updateDate()
        //checkAttendance()
        //updateAttendanceData()
        //signInTableView.delegate = self
        //signInTableView.dataSource = self
        //loadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func updateDate(){
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        let mySubstring = myStringafd.prefix(6).suffix(3)
        //let finDate = "\(self.util.month[String(mySubstring)]!)/\(myStringafd.prefix(2))"
        self.date = (self.util.month[String(mySubstring)]!,String(myStringafd.prefix(2)))
        print("date tester: \(self.date)")
    }
    
    func isValidEmail(emailAddressString: String) -> Bool {
        if(emailAddressString.trimmingCharacters(in: .whitespaces) == "") {return true}
        if(emailAddressString.filter { $0 == "@" }.count > 1) {return false}
        var test = emailAddressString.split(separator: "@")
        if(test.count == 2){
            print(test)
            if(test[1].split(separator: ".").count == 2){
                return true
            }
        }
        return false
    }
    
    @IBAction func guestSignInButton(_ sender: UIButton) {
        let letters = NSCharacterSet.letters
        let alert = UIAlertController(title: "Saved Successfully", message: "Changes to Church member saved successfully", preferredStyle: UIAlertController.Style.alert)
        if(firstNameText.text!.rangeOfCharacter(from: letters) == nil || firstNameText.text == ""){
            alert.title = "Invalid First Name"
            alert.message = "First name either contains numbers and symbols or is empty"
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if(lastNameText.text!.rangeOfCharacter(from: letters) == nil || lastNameText.text == ""){
            alert.title = "Invalid Last Name"
            alert.message = "Last name either contains numbers and symbols or is empty"
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if(!isValidEmail(emailAddressString: self.emailText.text!)){
            alert.title = "Invalid Email Address"
            alert.message = "Please enter a valid Email address"
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.db.collection("Metadata").document("guestMetadata").updateData([
                "length":String(self.indexId + 1)
                ])
            
            let indexDate = "\(self.date.0),\(self.date.1)"
            self.db.collection("AttendanceData").document("\(indexDate) \(indexId) guest").setData([
                "First":firstNameText.text!,
                "Last":lastNameText.text!,
                "Email":emailText.text!,
                "Attendance":true,
                "Date":"\(self.date.0)/\(self.date.1)",
                "indexId":(-indexId)
                ])
        }
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "backGuestSegue", sender: nil)
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
