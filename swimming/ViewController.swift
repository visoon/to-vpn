//
//  ViewController.swift
//  swimming
//
//  Created by 王翔 on 11/08/2017.
//  Copyright © 2017 vison. All rights reserved.
//

import UIKit
import NetworkExtension

class ViewController: UIViewController {
    @IBOutlet weak var connectButton: UIButton!
    
    var status: VPNStatus {
        didSet(o) {
            updateConnectButton()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.status = .off
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(onVPNStatusChanged), name: NSNotification.Name(rawValue: kProxyServiceVPNStatusNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.status = VpnManager.shared.vpnStatus
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func onVPNStatusChanged(){
        self.status = VpnManager.shared.vpnStatus
    }

    func updateConnectButton(){
        switch status {
        case .connecting:
            connectButton.setTitle("connecting", for: UIControlState())
        case .disconnecting:
            connectButton.setTitle("disconnect", for: UIControlState())
        case .on:
            connectButton.setTitle("Disconnect", for: UIControlState())
        case .off:
            connectButton.setTitle("Connect", for: UIControlState())
            
        }
        connectButton.isEnabled = [VPNStatus.on,VPNStatus.off].contains(VpnManager.shared.vpnStatus)
    }
    
    @IBAction func touch(_ sender: Any) {

        print("connect tap")
        if(VpnManager.shared.vpnStatus == .off){
            VpnManager.shared.connect()
        }else{
            VpnManager.shared.disconnect()
        }
    }

}

