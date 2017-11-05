//
//  TTBaseTableViewController.swift
//  swimming
//
//  Created by 王翔 on 22/08/2017.
//  Copyright © 2017 vison. All rights reserved.
//

import UIKit

class TTBaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func showAlert(message msg: String) {
        let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: nil)
        let alertController = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
