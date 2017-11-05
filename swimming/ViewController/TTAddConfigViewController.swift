//
//  TTAddConfigViewController.swift
//  swimming
//
//  Created by 王翔 on 22/08/2017.
//  Copyright © 2017 vison. All rights reserved.
//

import UIKit

class TTAddConfigViewController: TTBaseTableViewController {
    
    var config: TTLineConfig?
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var methodTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var remarkTextField: UITextField!
    
    @IBAction func comebackFromMethodSelected(segue: UIStoryboardSegue) {
        if segue.identifier == "comebackFromMethodSelected" {
            let sourceController = segue.source as! TTPwdViewController
            self.methodTextField.text = sourceController.method
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let config = self.config {
            self.addressTextField.text = config.address
            self.portTextField.text = String(config.port)
            self.methodTextField.text = config.method
            self.passwordTextField.text = config.password
            self.remarkTextField.text = config.remark
        }
    }
    
    @IBAction func onSaveAction(_ sender: UIBarButtonItem) {
        if TTLineCacheManager.manager.load().count > 10 {
            self.showAlert(message: "最多添加10条线路")
            return;
        }
        if self.addressTextField.text?.characters.count == 0 {
            self.showAlert(message: "请输入服务器地址")
            return
        }
        if self.portTextField.text?.characters.count == 0 {
            self.showAlert(message: "请输入端口号")
            return
        }
        if self.methodTextField.text?.characters.count == 0 {
            self.showAlert(message: "请选择加密方式")
            return
        }
        if self.passwordTextField.text?.characters.count == 0 {
            self.showAlert(message: "请输入密码")
            return
        }
        
        //修改
        if let config = self.config {
            self.setupConfig(config)
            if config.identity == TTLineCacheManager.manager.currentConfig().identity {
                let _ = TTLineCacheManager.manager.updateCurrentConfig(config: config)
            }
            let success = TTLineCacheManager.manager.update(config: config)
            if success {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        //新添加
        let newConfig = TTLineConfig()
        self.setupConfig(newConfig)
        
        let success = TTLineCacheManager.manager.save(config: newConfig)
        if success {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.showAlert(message: "保存失败!")
        }
        
    }
    
    fileprivate func setupConfig(_ config: TTLineConfig) {
        config.address = self.addressTextField.text
        config.port = Int64(self.portTextField.text!)
        config.method = self.methodTextField.text
        config.password = self.passwordTextField.text
        config.remark = self.remarkTextField.text?.characters.count == 0 ? self.addressTextField.text : self.remarkTextField.text
    }
}
