//
//  TTLineCacheManager.swift
//  swimming
//
//  Created by 王翔 on 22/08/2017.
//  Copyright © 2017 vison. All rights reserved.
//

import UIKit

let kTTLocalConfigListKey = "kTTLocalConfigListKey"
let kTTCurrentConfigKey = "kTTCurrentConfigKey"
let kTTDefaultConfigKey = "kTTDefaultConfigKey"

class TTLineCacheManager: NSObject {
    
    //MARK: - public methods
    static let manager = TTLineCacheManager()
    static var configChangedBlock: ((Void) -> Void)?
    
    func currentConfig() -> TTLineConfig {
        let config = self.loadObject(with: kTTCurrentConfigKey)
        if config is NSNull {
            let defaultConfig = self.japanDefaultConfig()
            let _ = self.updateCurrentConfig(config: defaultConfig)
            return defaultConfig
        }
        return config as! TTLineConfig
    }
    
    func updateCurrentConfig(config: TTLineConfig) -> Bool {
        let success = self.saveObjec(config, of: kTTCurrentConfigKey)
        
        if success && TTLineCacheManager.configChangedBlock != nil{
            TTLineCacheManager.configChangedBlock!()
        }
        return success
    }
    
    func japanDefaultConfig() -> TTLineConfig {
        var config = self.loadObject(with: kTTDefaultConfigKey)
        if config is NSNull {
            config = self.defaultConfig()
            let _ = self.saveObjec(config, of: kTTDefaultConfigKey)
        }
        return config as! TTLineConfig
    }
    
    func save(config: TTLineConfig) -> Bool {
        var localConfigs = self.localConfigs()
        localConfigs.append(config)
        return self.saveConfigs(configs: localConfigs)
    }
    
    func update(config: TTLineConfig) -> Bool {
        var localConfigs = self.localConfigs()
        var localConfig: TTLineConfig?
        for aConfig in localConfigs {
            if aConfig.identity == config.identity {
                localConfig = aConfig
                break
            }
        }
        
        guard localConfig != nil else {
            return false
        }
        
        let index = localConfigs.index(of: localConfig!)
        localConfigs[index!] = config
        return self.saveConfigs(configs: localConfigs)
    }
    
    func delete(config: TTLineConfig) -> Bool {
        var localConfigs = self.localConfigs()
        for localConf in localConfigs {
            if localConf.identity == config.identity {
                let index = localConfigs.index(of: localConf)
                localConfigs.remove(at: index!)
                break
            }
        }
        return self.saveConfigs(configs: localConfigs)
    }
    
    func load() -> [TTLineConfig] {
        return self.localConfigs()
    }
    
    //MARK: - private methods
    fileprivate func saveConfigs(configs: [TTLineConfig]) -> Bool {
        return self.saveObjec(configs, of: kTTLocalConfigListKey)
    }
    
    fileprivate func localConfigs() -> [TTLineConfig] {
        let configs = self.loadObject(with: kTTLocalConfigListKey)
        guard !(configs is NSNull) else {
            return [TTLineConfig]()
        }
        let localConfigs: [TTLineConfig] =  configs as! [TTLineConfig]
        return localConfigs
    }
    
    fileprivate func defaultConfig() -> TTLineConfig{
        let defaultConfig = TTLineConfig()
        defaultConfig.address = "45.76.211.209"
        defaultConfig.port = 33721
        defaultConfig.method = "AES-256-CFB"
        defaultConfig.password = "jay..."
        defaultConfig.remark = "默认路线(日本)"
        defaultConfig.isDefault = true
        return defaultConfig
    }
    
    fileprivate func saveObjec(_ object: Any, of key: String) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.set(data, forKey: key)
        return UserDefaults.standard.synchronize()
    }
    
    fileprivate func loadObject(with key: String) -> Any {
        let data = UserDefaults.standard.value(forKey: key) as? Data
        guard data != nil else {
            return NSNull()
        }
        let object = NSKeyedUnarchiver.unarchiveObject(with: data!)
        return object ?? NSNull()
    }
}

class TTLineConfig: NSObject, NSCoding {
    var identity: String!
    var address: String!
    var port: Int64!
    var method: String!
    var password: String!
    var remark: String?
    var isDefault: Bool!
    
    override init() {
        super.init()
        
        self.identity = ("\(Date().timeIntervalSince1970)")
        self.isDefault = false
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        identity = aDecoder.decodeObject(forKey: "identity") as! String
        address = aDecoder.decodeObject(forKey: "address") as! String
        port = aDecoder.decodeObject(forKey: "port") as! Int64
        method = aDecoder.decodeObject(forKey: "method") as! String
        password = aDecoder.decodeObject(forKey: "password") as! String
        remark = aDecoder.decodeObject(forKey: "remark") as? String
        isDefault = aDecoder.decodeObject(forKey: "isDefault") as? Bool
    }
    

    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(identity, forKey: "identity")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(port, forKey: "port")
        aCoder.encode(method, forKey: "method")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(remark, forKey: "remark")
        aCoder.encode(isDefault, forKey: "isDefault")
    }
}

