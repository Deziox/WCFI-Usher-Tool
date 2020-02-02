//
//  ViewController.swift
//  WCFI People Info
//
//  Created by DeZiox on 12/23/18.
//  Copyright © 2018 DeZiox. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class LoginViewController: UIViewController,UITextFieldDelegate{

    //MARK: Login
    @IBOutlet weak var passText: UITextField!
    
    let db = Firestore.firestore()
    var password:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        passText.delegate = self
        
        self.db.collection("Metadata").document("loginInfo").getDocument{
            (document,error) in
            if let document = document, document.exists {
                self.password = document.data()!["pwaosrsd"] as! String
            } else {
                print("loginInfo does not exist in database")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK: ButtonActions
    @IBAction func loginButton(_ sender: UIButton) {
        //Checks user:pass data of available Ushers and compares it to the text from the TextFields of userText and passText Respectively
        //use tuples buddy
        //if swift even has tuples lol
        login()
        
    }
    
    func login(){
        if (self.passText.text == ""){
            let alert = UIAlertController(title: "password contains nothing", message: "password cannot be left empty", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            
            if(passText.text! == self.password){
                print("Ay yeet")
                self.performSegue(withIdentifier: "menuSegue", sender: nil)
            }else{
                print("Nah chief")
                let alert = UIAlertController(title: "Email or password incorrect", message: "Email/password combo incorrect", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            /*
            Auth.auth().signIn(withEmail: "wcfiusher", password: passText.text!) { (user, error) in
                
                if(error == nil){
                    print("Ay yeet")
                    self.performSegue(withIdentifier: "menuSegue", sender: nil)
                }else{
                    print("Nah chief")
                    let alert = UIAlertController(title: "Email or password incorrect", message: "Email/password combo incorrect", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            */
        }
    }

}
