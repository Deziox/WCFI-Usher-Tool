//
//  SignInViewController.swift
//  WCFI People Info
//
//  Created by DeZiox on 1/9/19.
//  Copyright © 2019 DeZiox. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignInViewController: UIViewController {
    
    var sections:[String] = []
    var members:[String:[String]] = [:]
    var finalMembers:[(String,[String])] = []
    var numberOfMembers : Int = 0
    let db = Firestore.firestore()
    let util = UTUtilities()
    var attendance:[String:Bool] = [:]
    var attendanceData:[String:Bool] = [:]
    var date:(String,String) = ("","")
    
    @IBOutlet weak var signInTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.signInTableView.reloadData()
        reset()
    }
    
    func reset(){
        updateDate()
        checkAttendance()
        print("te \(self.attendance)")
        updateAttendanceData()
        signInTableView.delegate = self
        signInTableView.dataSource = self
        loadData()
    }
    
    func updateAttendanceData(){
        self.db.collection("AttendanceData").getDocuments{(querySnapshot,err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else {
                let dateCheck = "\(self.date.0)/\(self.date.1)"
                for document in querySnapshot!.documents{
                    if(dateCheck == (document.data()["Date"] as! String)){
                        self.attendanceData[(document.data()["indexId"] as! String)] = (document.data()["Attendance"] as! Bool)
                    }
                }
            }
        }
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
    
    func checkAttendance(){
        db.collection("AttendanceData").getDocuments{ (querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else{
                for document in querySnapshot!.documents{
                    //print(document.data()["Attendance"] as! Bool)
                    self.attendance[(document.data()["indexId"] as! String)] = (document.data()["Attendance"] as! Bool)
                }
                //print(self.attendance)
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backSegue", sender: nil)
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

extension SignInViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //loadData()
        //print("test 4 \(self.sections)")
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("test3 \(self.numberOfMembers)")
        return self.finalMembers[section].1.count
    }
    
    func loadData(){
        self.members = [:]
        self.finalMembers = []
        self.db.collection("Members").getDocuments { (querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else {
                if (self.members.isEmpty){
                    for document in querySnapshot!.documents {
                        self.numberOfMembers += 1
                        if(!self.sections.contains(document.data()["Last"] as! String)){
                            self.sections.append(document.data()["Last"] as! String)
                            self.sections = self.sections.sorted()
                            print("section sort test \(self.sections)")
                        }
                        if(self.members[document.data()["Last"] as! String] == nil){
                            self.members[document.data()["Last"] as! String] = ["\(document.data()["First"] as! String) \(document.documentID)"]
                        }else{
                            self.members[document.data()["Last"] as! String]!.append("\(document.data()["First"] as! String) \(document.documentID)")
                            self.members[document.data()["Last"] as! String]!.sort()
                        }
                    }
                    self.sortMembers()
                }
            }
            self.signInTableView.reloadData()
        }
    }
    
    func sortMembers(){
        let test = self.members.sorted{ (aDic,bDic) -> Bool in
            return aDic.key < bDic.key
        }
        print("wut \(test)")
        self.finalMembers = test
        print("finished sorting: \(self.finalMembers)")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignIdentifier",for: indexPath) as! SignInTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let nameIndex = finalMembers[indexPath.section].1[indexPath.row].components(separatedBy: " ")
        cell.textLabel!.text = nameIndex[0]
        cell.listIndex = nameIndex[1]
        if(attendance[nameIndex[1]] ?? false){
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    func checkAttendanceData(memberToCheck:String) -> Bool{
        //check if database container contains member for that specific date
        if(self.attendanceData[memberToCheck] != nil){return true}
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //checkAttendanceData((cell as! SignInTableViewCell).listIndex)
        var att:Bool = false
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                /*
                self.db.collection("AttendanceData").document((cell as! SignInTableViewCell).listIndex).updateData([
                    "Attendance": false
                    
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }*/
            }
            else{
                cell.accessoryType = .checkmark
                att = true
            }
            
            let indexDate = "\(self.date.0),\(self.date.1)"
            let indexId = (cell as! SignInTableViewCell).listIndex
            if(checkAttendanceData(memberToCheck: (cell as! SignInTableViewCell).listIndex)){
                //  change existing to value of att
                //self.db.collection("AttendanceData")
                    //.whereField("indexId", isEqualTo: (cell as! SignInTableViewCell).listIndex)
                    //.whereField("Date", isEqualTo: self.date)
                self.db.collection("AttendanceData").document("\(indexDate) \(indexId)").updateData([
                    "Attendance":att
                ])
            }else{
                //  add to database; set to value of att
                self.db.collection("AttendanceData").document("\(indexDate) \(indexId)").setData([
                    "Attendance":att,
                    "Date":"\(self.date.0)/\(self.date.1)",
                    "indexId":"\((cell as! SignInTableViewCell).listIndex)"
                    ])
            }
            self.reset()
        }
        
    }
}
