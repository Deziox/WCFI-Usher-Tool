//
//  EditorViewController.swift
//  WCFI People Info
//
//  Created by DeZiox on 1/15/19.
//  Copyright © 2019 DeZiox. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseFirestore

class EditorViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource{
    

    var firstName:String = ""
    var lastName:String = ""
    var email:String = ""
    var birthday:String = ""
    var bibleStudy:String = ""
    var indexId:String = ""
    
    let month:[String] = (Array(1...12)).map{ String(format: "%02d", $0) }
    let day:[String] = (Array(1...31)).map{ String(format: "%02d", $0) }
    let bSG:[String] = ["Chester","Delaware","Ewing","Hamilton","Lodi","Monroe","North Brunswick","Princeton","Riegelsville","Somerset","Tinton"]
    let bSGtoIndex:[String:Int] = ["Chester":0,"Delaware":1,"Ewing":2,"Hamilton":3,"Lodi":4,"Monroe":5,"North Brunswick":6,"Princeton":7,"Riegelsville":8,"Somerset":9,"Tinton":10]
    //String(format: "%02d", myInt)
    
    let db = Firestore.firestore()
    let util = UTUtilities()
    
    //MARK: Text fields
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var birthdayText: UITextField!
    @IBOutlet weak var bibleStudyText: UITextField!
    
    let birthdayPicker = UIPickerView()
    let bSGPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        firstNameText.text = firstName
        lastNameText.text = lastName
        emailText.text = email
        birthdayText.text = birthday
        bibleStudyText.text = bibleStudy
        
        birthdayPicker.delegate = self
        birthdayText.inputView = birthdayPicker
        birthdayPicker.selectRow(Int(birthday.prefix(2))! - 1, inComponent: 0, animated: true)
        birthdayPicker.selectRow(Int(birthday.suffix(2))! - 1, inComponent: 1, animated: true)
        
        bSGPicker.delegate = self
        bSGPicker.selectRow(bSGtoIndex[bibleStudy]!, inComponent: 0, animated: true)
        bibleStudyText.inputView = bSGPicker
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if(pickerView == birthdayPicker){
            return 2
        }else{
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == birthdayPicker){
            if(component == 0){
                return month.count
            }else{
                return day.count
            }
        }else{
            return bSG.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == birthdayPicker){
            if(component == 0){
                return month[row]
            }else{
                return day[row]
            }
        }else{
            print("test thing")
            return bSG[row]
        }
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
    
    func isValidBirthday(testStr:String) -> Bool {
        if(testStr.filter { $0 == "/" }.count > 1) {return false}
        var test = testStr.split(separator: "/")
        if(test.count == 2){
            print("\(test)")
            if(test[0].count == 2 && test[1].count == 2){
                print("yas \(test)")
                if(CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: String(test[0]))) && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: String(test[1])))){
                    print("yas2 \(test)")
                    return true
                }
            }
        }
        return false
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == birthdayPicker){
            let pickedMonth = month[pickerView.selectedRow(inComponent: 0)]
            let pickedDay = day[pickerView.selectedRow(inComponent: 1)]
            birthday = "\(pickedMonth)/\(pickedDay)"
            birthdayText.text = birthday
        }else{
            bibleStudy = bSG[row]
            bibleStudyText.text = bibleStudy
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "backEditAddSegue", sender: nil)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
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
        }else if(!isValidBirthday(testStr: self.birthdayText.text!)){
            alert.title = "Invalid Birthday date"
            alert.message = "Birthday must be in the format mm/dd"
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if(bibleStudy.rangeOfCharacter(from: letters) == nil){
            alert.title = "Invalid Bible Study Group"
            alert.message = "invalid bible study group"
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            firstName = firstNameText.text ?? ""
            lastName = lastNameText.text ?? ""
            email = emailText.text ?? ""
            birthday = birthdayText.text ?? "00/00"
            bibleStudy = bibleStudyText.text ?? ""
            
            self.db.collection("Members").document(self.indexId).updateData([
                "First":firstName,
                "Last":lastName,
                "Email":email,
                "Birthday":birthday,
                "BS":bibleStudy
            ]){err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    alert.title = "Changes Saved Successfully"
                    alert.message = "Church member changes edited succesfully"
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
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
