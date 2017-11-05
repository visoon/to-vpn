//
//  TTConfigListViewController.swift
//  swimming
//
//  Created by 王翔 on 22/08/2017.
//  Copyright © 2017 vison. All rights reserved.
//

import UIKit

class TTConfigListViewController: TTBaseTableViewController {
    @IBOutlet weak var addCell: UITableViewCell!
    @IBOutlet weak var defaultLineCell: UITableViewCell!
    
    var datasource = Array<[TTLineConfig]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
        self.tableView.reloadData()
    }
    
    func initUI() {
        self.tableView.register(TTConfigCell.self, forCellReuseIdentifier: TTConfigCell.reuseIdentifier())
    }
    
    func loadData() {
        self.datasource.removeAll()
        let defaultConfigs = [TTLineCacheManager.manager.japanDefaultConfig()]
        let customConfigs = TTLineCacheManager.manager.load()
        self.datasource.append(defaultConfigs)
        self.datasource.append(customConfigs)
    }
    
    //MARK: UITableView delegate / datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return (self.datasource[section - 1]).count
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        let currentConfig = self.datasource[indexPath.section - 1][indexPath.row]
        if currentConfig.identity == TTLineCacheManager.manager.currentConfig().identity {
            return
        }
        
        let _ = TTLineCacheManager.manager.updateCurrentConfig(config: currentConfig)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return self.addCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TTConfigCell.reuseIdentifier()) as! TTConfigCell
            cell.config = self.datasource[indexPath.section - 1][indexPath.row]
            cell.infoBlock = { config in
                let configVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TTAddConfigViewController") as! TTAddConfigViewController
                configVC.config = cell.config
                self.navigationController?.pushViewController(configVC, animated: true)
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 || indexPath.section == 1{
            return false
        }
        let config = self.datasource[indexPath.section - 1][indexPath.row]
        if config.identity == TTLineCacheManager.manager.currentConfig().identity {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction.init(style: .default, title: "删除") { (action, indexPath) in
            let config = self.datasource[indexPath.section - 1][indexPath.row]
            let success = TTLineCacheManager.manager.delete(config: config)
            if success {
                self.datasource[1].remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            }
        }
        return [action]
    }
}
