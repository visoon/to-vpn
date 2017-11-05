//
//  TTHomeViewController.swift
//  swimming
//
//  Created by 王翔 on 22/08/2017.
//  Copyright © 2017 vison. All rights reserved.
//

import UIKit


class TTHomeViewController: TTBaseTableViewController {
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var currentConfigTitleLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    var status : VPNStatus {
        didSet {
            self.updateButtonStatus()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.status = .off
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(onVpnStatusChanged), name: Notification.Name(kProxyServiceVPNStatusNotification), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentConfigTitleLabel.text = TTLineCacheManager.manager.currentConfig().remark
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.status = .off
        
        TTLineCacheManager.configChangedBlock = {
            if VpnManager.shared.vpnStatus == .on {
                VpnManager.shared.disconnect()
            }
        }
    }


    //MARK: private methods
    func updateButtonStatus()  {
        
        switch self.status {
        case .off:
            self.switchButton.isHidden = false
            self.switchButton.setOn(false, animated: true)
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
        case .connecting:
            self.switchButton.isHidden = true
            self.indicatorView.startAnimating()
            self.indicatorView.isHidden = false
        case .on:
            self.switchButton.isHidden = false
            self.switchButton.setOn(true, animated: true)
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
        case .disconnecting:
            self.switchButton.isHidden = true
            self.indicatorView.startAnimating()
            self.indicatorView.isHidden = false
        }
    }
    
    func onVpnStatusChanged() {
        self.status = VpnManager.shared.vpnStatus
    }
    
    
    //MARK: response methods
    @IBAction func onSwitchAction(_ sender: UISwitch) {
        if VpnManager.shared.vpnStatus == .off &&
            sender.isOn == true{
            VpnManager.shared.connect()
        }
        
        if VpnManager.shared.vpnStatus == .on &&
            sender.isOn == false{
            VpnManager.shared.disconnect()
        }

    }
}
