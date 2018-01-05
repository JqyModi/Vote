//
//  VoteListModel.swift
//  Vote
//
//  Created by mac on 2018/1/4.
//  Copyright © 2018年 modi. All rights reserved.
//

import UIKit

class VoteListModel: NSObject {
    
    @objc var title: String?
    @objc var total: String?
    @objc var desc: String?
    @objc var image: String?
    @objc var video: String?
    
    init(dict: [String:Any]?) {
        super.init()
        if let dict = dict as? [String:Any] {
            setValuesForKeys(dict)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String {
        //运行时获取到属性列表
        var count = UInt32.init(0)
        let list = class_copyPropertyList(self.classForCoder, &count)
        for i in 0..<count {
            let pro = list![Int(i)]
            //UnsafePointer<Int8>
            let nameAddr = property_getName(pro)
            //将UnsafePointer<Int8>转为String
            let name = NSString(utf8String: nameAddr)
            debugPrint("name ----> \(name)")
        }
        return dictionaryWithValues(forKeys: ["title","total","desc","image","video"]).description
    }
}
