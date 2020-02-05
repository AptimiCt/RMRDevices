//
//  DetailViewController.swift
//  RMRDevices
//
//  Created by Александр Востриков on 05.02.2020.
//  Copyright © 2020 Александр Востриков. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var deviceDetail: Device? = nil
    
    
    @IBOutlet var deviceName: UILabel!
    @IBOutlet var osName: UILabel!
    @IBOutlet var devicceYear: UILabel!
    @IBOutlet var deviceCreated: UILabel!
    @IBOutlet var platform: UILabel!
    
    @IBOutlet var imageDetailView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceName.text = deviceDetail?.name
        osName.text = deviceDetail?.os
        devicceYear.text = deviceDetail?.year
        platform.text = deviceDetail?.platform
        imageDetailView.image = UIImage(named: "logo")
    }
    override func viewWillLayoutSubviews() {
        imageDetailView.layer.cornerRadius = imageDetailView.bounds.width / 3
    }
    
}
