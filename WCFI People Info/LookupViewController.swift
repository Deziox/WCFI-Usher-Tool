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

class LookupViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    
    @IBOutlet weak var testScroll: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func testAdd(_ sender: UIButton) {
        var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        ref = db.collection("Members").addDocument(data: [
            "First": "Danzel",
            "Last": "Serrano",
            "Email": "dezioxe@gmail.com"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        displayData()
    }
    
    func displayData(){
        let db = Firestore.firestore()
        db.collection("Members").getDocuments(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.testLabel.text = "\(document.documentID) => \(document.data()["Email"] ?? "")"
                    let name = "\(document.data()["Last"] ?? ""), \(document.data()["First"] ?? "")"
                    self.testScroll.text = self.testScroll.text.appending("\(document.documentID))\(name)\n\tEmail: \(document.data()["Email"] ?? "")\n")
                }
            }
        })
    }
    
    @IBAction func testDB(_ sender: UIButton) {
        displayData()
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
