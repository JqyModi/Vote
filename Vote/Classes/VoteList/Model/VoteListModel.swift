//
//  VoteListModel.swift
//  Vote
//
//  Created by mac on 2018/1/4.
//  Copyright © 2018年 modi. All rights reserved.
//

import UIKit

class VoteListModel: NSObject {
    /**
    "id":"3975",
    "name":"666",
    "piao":"5",
    "remark":"adsas",
    "img_url_s":"./thumb_1.jpg",
    "video_url":"2.mp4"
     */
    
    @objc var name: String?
    @objc var piao: String?
    @objc var remark: String?
    @objc var img_url_s: String?
    @objc var video_url: String?
    
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
//            debugPrint("name ----> \(name)")
        }
        return dictionaryWithValues(forKeys: ["name","piao","remark","img_url_s","video_url"]).description
    }
}
