//
//  LookupViewController.swift
//  WCFI People Info
//
//  Created by DeZiox on 1/5/19.
//  Copyright © 2019 DeZiox. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class LookupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let myPickerData = ["Last Name","First Name","Email","Birthday","BS Group"]
    var initLabelText = "Last Name"
    var forwardSeg:Bool = true
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myPickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(String(myPickerData[row]))
        categoryLabel.text = myPickerData[row]
    }
    
    @IBOutlet weak var pickerViewShower: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var searchParamsTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //let thePicker = UIPickerView()
        self.forwardSeg = true
        self.pickerViewShower.isHidden = true
        self.pickerViewShower.alpha = 0
        self.categoryLabel.text = initLabelText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(forwardSeg){
            let recieverVC = segue.destination as! TableViewController
            recieverVC.category = self.categoryLabel.text?.components(separatedBy: " ")[0]
            recieverVC.searchParams = self.searchParamsTF.text
        }
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "searchedSegue", sender: nil)
    }
    
    
    @IBAction func searchByButton(_ sender: UIButton) {
        self.pickerViewShower.isHidden = false
        UIView.animate(withDuration: 0.75) {
            self.pickerViewShower.alpha = 1.0
        }
    }
    
    @IBAction func doneWithCategoryButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.4) {
            self.pickerViewShower.alpha = 0
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.forwardSeg = false
        self.performSegue(withIdentifier: "backSegue", sender: nil)
    }
    
    
    /*
    @IBAction func testAdd(_ sender: UIButton) {
        //var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        db.collection("Members").document("3").setData([
            "First": "Danzel",
            "Last": "Serrano",
            "Email": "dezioxe@gmail.com",
            "Birthday": "06/10",
            "BS": "princeton"
        ])
        displayData()
    }
    */
    
    /*
    func displayData(){
        self.testScroll.text = ""
        let db = Firestore.firestore()
        db.collection("Members").getDocuments(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let name = "\(document.data()["Last"] ?? ""), \(document.data()["First"] ?? "")"
                    self.testScroll.text = self.testScroll.text.appending("\(document.documentID))\(name)\n\tEmail: \(document.data()["Email"] ?? "")\n")
                }
            }
        })
    }
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
