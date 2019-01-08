//
//  SettingsViewController.swift
//  WCFI People Info
//
//  Created by DeZiox on 1/5/19.
//  Copyright © 2019 DeZiox. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
     @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "menuSegue", sender: nil)
     }
    
    @IBAction func logOutButton(_ sender: UIButton) {
        performSegue(withIdentifier: "logOutSegue", sender: nil)
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
