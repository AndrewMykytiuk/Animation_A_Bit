//
//  ButtonsTableViewCell.swift
//  AnimationX
//
//  Created by User on 18/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit

class ButtonsTableViewCell: UITableViewCell {

    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
