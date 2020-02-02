//
//  TableViewCell.swift
//  RMRDevices
//
//  Created by Александр Востриков on 15.01.2020.
//  Copyright © 2020 Александр Востриков. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var nameDevice: UILabel!
    @IBOutlet var osDevice: UILabel!
    @IBOutlet var labelInfo: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var imageViewCell: UIImageView!
    
    var uid: String = ""
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

}
