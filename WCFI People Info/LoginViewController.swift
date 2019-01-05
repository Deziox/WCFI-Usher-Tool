//
//  ViewController.swift
//  WCFI People Info
//
//  Created by DeZiox on 12/23/18.
//  Copyright © 2018 DeZiox. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    //MARK: Login
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var userText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: ButtonActions
    @IBAction func loginButton(_ sender: UIButton) {
        //Checks user:pass data of available Ushers and compares it to the text from the TextFields of userText and passText Respectively
        //use tuples buddy
        //if swift even has tuples lol
        login()
        
    }
    
    func login(){
        if (self.passText.text == "" || self.userText.text == ""){
            let alert = UIAlertController(title: "Email or password contains nothing", message: "Email and/or password cannot be left empty", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            
            Auth.auth().signIn(withEmail: userText.text!, password: passText.text!) { (user, error) in
                
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
            
        }
    }

}
