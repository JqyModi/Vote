//
//  NetworkTools.swift
//  Vote
//
//  Created by mac on 2018/1/5.
//  Copyright © 2018年 modi. All rights reserved.
//

import UIKit

class NetworkTools: NSObject {
    
    var value: Int = 0
    
    //swift3.0推荐使用：创建单例
    private static let sharedInstance = NetworkTools()
    class var sharedSingleton: NetworkTools {
        return sharedInstance
    }
    
    //私有化构造方法
    private override init() {}
    
    /**
     *  Desc: 获取当前活动截止时间
     *  Param: url 请求URL：http://shiyan360.cn/api/activity
     */
    func requestDeadline(urlStr: String, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Swift.Void)) {
        let url = URL(string: urlStr)
        //一般用苹果提供的单例：自定义时需要指定config
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                completionHandler(data, response, error)
//                debugPrint("data = \(data)")
//                debugPrint("response = \(response)")
            }else{
                debugPrint("error = \(error)")
            }
        }
        //一定要手动开始任务：默认挂起状态
        dataTask.resume()
    }
}
