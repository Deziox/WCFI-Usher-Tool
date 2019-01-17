//
//  EditMembersViewController.swift
//  WCFI People Info
//
//  Created by DeZiox on 1/11/19.
//  Copyright © 2019 DeZiox. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
class EditMembersViewController: UIViewController {
    
    var testThing:[[String:Any]] = []
    var sendData:[String:Any] = [:]
    let db = Firestore.firestore()
    
    let deleteAlert = UIAlertController(title: "Are you sure?", message: "Data for church member will be deleted permanently, you'll have to add them back", preferredStyle: UIAlertController.Style.alert)
    
    var cellToDel:EditMembersTableViewCell = EditMembersTableViewCell()
    var cellToDelIndexPath:IndexPath?
    
    @IBOutlet weak var editTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.editTableView.rowHeight = 45
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteMember(id: self.cellToDel.indexId)
            self.editTableView.deleteRows(at: [self.cellToDelIndexPath!], with: .left)
            self.db.collection("Members").document(self.cellToDel.indexId).delete(){ err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }))
        
        reset()
    }
    
    func reset(){
        //updateDate()
        //checkAttendance()
        //updateAttendanceData()
        loadData()
        editTableView.delegate = self
        editTableView.dataSource = self
    }
    
    func loadData(){
        self.testThing = []
        db.collection("Members").getDocuments { (querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else {
                print(self.testThing)
                if (self.testThing.isEmpty){
                    for document in querySnapshot!.documents {
                        var data = document.data()
                        data["indexId"] = document.documentID
                        self.testThing.append(data)
                    }
                }
                self.sortMembers()
                self.editTableView.reloadData()
            }
        }
    }

    func sortMembers(){
        let test = self.testThing.sorted { (a,b) -> Bool in
            return (a["Last"] as! String) < (b["Last"] as! String)
        }
        self.testThing = test
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "backEditSegue", sender: nil)
    }
    
    @IBAction func addNewMemberButton(_ sender: UIButton) {
        //deleteMember(id: "1")
    }
    
    func deleteMember(id: String){
        for i in 0...(self.testThing.count - 1){
            if((self.testThing[i]["indexId"] as! String) == id){
                self.testThing.remove(at: i)
                break
            }
        }
        //self.editTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editMemberSegue"){
            let recieverVC = segue.destination as! EditorViewController
            recieverVC.firstName = sendData["First"] as! String
            recieverVC.lastName = sendData["Last"] as! String
            recieverVC.bibleStudy = sendData["BS"] as! String
            recieverVC.email = sendData["Email"] as! String
            recieverVC.birthday = sendData["Birthday"] as! String
            recieverVC.indexId = sendData["indexId"] as! String
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

extension EditMembersViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.testThing.isEmpty){
            return 0
        }else{
            return self.testThing.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath){
            sendData = (cell as! EditMembersTableViewCell).data
        }
        performSegue(withIdentifier: "editMemberSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditIdentifier", for: indexPath) as! EditMembersTableViewCell
        print(indexPath.row)
        print(testThing[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if(!self.testThing.isEmpty){
            let txt = "\(testThing[indexPath.row]["First"]!) \(testThing[indexPath.row]["Last"]!)"
            cell.textLabel!.text = txt
        }
        cell.indexId = testThing[indexPath.row]["indexId"] as! String
        cell.data = testThing[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        cellToDel = tableView.cellForRow(at: indexPath as IndexPath) as! EditMembersTableViewCell
        cellToDelIndexPath = indexPath
        if(editingStyle == .delete){
            present(deleteAlert, animated: true, completion: nil)
        }
    }
}
