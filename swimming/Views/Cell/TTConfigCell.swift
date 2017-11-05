//
//  TTConfigCell.swift
//  swimming
//
//  Created by 王翔 on 25/08/2017.
//  Copyright © 2017 vison. All rights reserved.
//

import UIKit

class TTConfigCell: UITableViewCell {

    
    var titleLabel: UILabel!
    var infoButton: UIButton!
    var infoBlock: ((TTLineConfig) -> ())?
    
    var config: TTLineConfig? {
        didSet {
            self.titleLabel.text = config?.remark ?? config?.address
            self.infoButton.isHidden = (config?.isDefault)!
            if config?.identity == TTLineCacheManager.manager.currentConfig().identity {
                self.accessoryType = .checkmark
            } else {
                self.accessoryType = .disclosureIndicator
            }
            self.setNeedsLayout()
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.infoButton.frame = CGRect(x: 15, y: 0, width: 30, height: self.contentView.bounds.size.height)
        
        let orignX = self.infoButton.isHidden == true ? 15 : self.infoButton.frame.maxX + 5
        self.titleLabel.frame = CGRect(x: orignX, y: 0, width: 200, height: self.contentView.bounds.size.height)
    }
    
    func initUI() {
        self.selectionStyle = .none
        
        self.titleLabel = UILabel()
        self.titleLabel.font = UIFont.systemFont(ofSize: 15)
        
        self.infoButton = UIButton(type: .infoLight)
        self.infoButton.addTarget(self, action: #selector(onInfoAction(_:)), for: .touchUpInside)
        
        self.contentView.addSubview(self.infoButton)
        self.contentView.addSubview(self.titleLabel)
    }
    
    //MARK: - response methods
    func onInfoAction(_ sender: UIButton) {
        guard let _ = self.infoBlock else {
            return
        }
        self.infoBlock!(self.config!)
    }
    
    
    //MARK: - public methods
    class func reuseIdentifier() -> String {
        return NSStringFromClass(self.superclass()!)
    }
    
}
