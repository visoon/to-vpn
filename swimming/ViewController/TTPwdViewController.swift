//
//  TTPwdViewController.swift
//  swimming
//
//  Created by 王翔 on 22/08/2017.
//  Copyright © 2017 vison. All rights reserved.
//

import UIKit

class TTPwdViewController: TTBaseTableViewController {

    var method: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        for view in cell!.contentView.subviews {
            guard view.isKind(of: UILabel.superclass()!) else {
                return
            }
            let label = view as! UILabel
            self.method = label.text!
            performSegue(withIdentifier: "comebackFromMethodSelected", sender: nil)
        }
    }
}
