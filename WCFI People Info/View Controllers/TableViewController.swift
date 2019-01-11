//
//  TableViewController.swift
//  WCFI People Info
//
//  Created by DeZiox on 1/8/19.
//  Copyright © 2019 DeZiox. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class TableViewController: UITableViewController {

    var category:String?
    var searchParams:String?
    var testThing:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.rowHeight = 95
        testThing = []
        print(category!)
        print(searchParams!)
        loadData()
    }
    
    func loadData(){
        self.testThing = []
        let db = Firestore.firestore()
        db.collection("Members").getDocuments { (querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else {
                if (self.testThing.isEmpty){
                    for document in querySnapshot!.documents {
                        if((self.searchParams?.isEmpty)!){
                            self.testThing.append(document.data())
                            continue
                        }
                        if(!(self.searchParams?.isEmpty)! && (document.data()[self.category!] as! String).lowercased().range(of: self.searchParams!) != nil){
                            self.testThing.append(document.data())
                        }
                    }
                }
                self.sortMembers()
                self.tableView.reloadData()
            }
        }
    }
    
    func sortMembers(){
        let test = self.testThing.sorted { (a,b) -> Bool in
            return (a["Last"] as! String) < (b["Last"] as! String)
        }
        self.testThing = test
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.testThing.isEmpty){
            return 0
        }else{
            return self.testThing.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! LookupTableViewCell
        if(!self.testThing.isEmpty){
            let txt = "\(testThing[indexPath.row]["First"]!) \(testThing[indexPath.row]["Last"]!):\n\tEmail: \(testThing[indexPath.row]["Email"]!)\n\tBirthday: \(testThing[indexPath.row]["Birthday"]!)\n\tBible Study Group: \(testThing[indexPath.row]["BS"]!)"
            cell.setContent(text: txt)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recieverVC = segue.destination as! LookupViewController
        if(self.category == "First" || self.category == "Last"){
            recieverVC.initLabelText = "\(self.category!) Name"
        }else if(self.category == "BS"){
            recieverVC.initLabelText = "\(self.category!) Group"
        }else{
            recieverVC.initLabelText = self.category!
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "backSegue", sender: nil)
    }
    
    
}
