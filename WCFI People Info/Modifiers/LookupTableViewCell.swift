//
//  LookupTableViewCell.swift
//  WCFI People Info
//
//  Created by DeZiox on 1/8/19.
//  Copyright © 2019 DeZiox. All rights reserved.
//

import UIKit

class LookupTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.content.isEditable = false
        // Configure the view for the selected state
    }
    
    func setContent(text : String){
        self.content.text = text
    }

}
