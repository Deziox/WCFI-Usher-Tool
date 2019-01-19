//
//  MenuViewController.swift
//  WCFI People Info
//
//  Created by DeZiox on 1/5/19.
//  Copyright © 2019 DeZiox. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    @IBAction func settings(_ sender: UIButton) {
        performSegue(withIdentifier: "settingsSegue", sender: nil)
    }
    
    @IBAction func lookupButton(_ sender: UIButton) {
        performSegue(withIdentifier: "lookupSegue", sender: nil)
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        performSegue(withIdentifier: "signSegue", sender: nil)
    }
    
    @IBAction func editButton(_ sender: UIButton) {
        performSegue(withIdentifier: "editSegue", sender: nil)
    }
    
    @IBAction func guestSignIn(_ sender: UIButton) {
        performSegue(withIdentifier: "guestSignInSegue", sender: nil)
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
