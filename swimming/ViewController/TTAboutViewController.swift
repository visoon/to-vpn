//
//  TTAboutViewController.swift
//  swimming
//
//  Created by 王翔 on 25/08/2017.
//  Copyright © 2017 vison. All rights reserved.
//

import UIKit

class TTAboutViewController: TTBaseTableViewController {

    
    @IBOutlet weak var versionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        self.versionLabel.text = version
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            UIApplication.shared.openURL(URL(string: "mailto://visoooon@gmail.com")!)
        }
        
        if indexPath.row == 1 {
            UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/us/app/to-vpn/id1278800568?l=zh&ls=1&mt=8")!)
        }
    }
}
