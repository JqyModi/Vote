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
    func requestDoGet(urlStr: String, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Swift.Void)) {
        //将str进行URL编码
        let urlEncode = NSString.init(string: urlStr).addingPercentEncoding(withAllowedCharacters: CharacterSet.init(charactersIn: urlStr))
        let url = URL(string: urlEncode!)
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
    
    /**
     *  Desc: 判断当前活动是否过期
     *  Param:
     */
    func isOverdue(completionHandler: @escaping ((_ isOverdue: Bool) -> ())) {
        //判断当前活动是否过期
        let urlStr = "http://shiyan360.cn/api/activity"
        requestDoGet(urlStr: urlStr) { (data, response, error) in
            if error == nil {
                debugPrint("data = \(data)")
                debugPrint("response = \(response)")
                
                //处理服务器返回来的数据
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    if let dict = json as? [String : Any] {
                        debugPrint("dict = \(dict)")
                        let endTime = dict["endtime"] as? TimeInterval
                        debugPrint("endTime = \(endTime)")
                        //比较当前时间与截止时间
                        completionHandler(self.compareEndTime(dict: dict))
                    }
                }catch {
                    debugPrint("catch error = \(error)")
                }
                
            }else{
                debugPrint("error = \(error)")
            }
        }
    }
    
    /**
     *  Desc: 比较当前时间与获取截止时间
     *  Param: dict 包含活动截止时间
     */
    private func compareEndTime(dict: [String : Any]?) -> Bool {
        //获取当前时间
        let currentTime = NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970
        debugPrint("currentTime = \(currentTime)")
        //获取活动截止时间
        let activityEndTime = dict!["endtime"] as! String
        //1515198865: 2018.01.06
        let endTime: Double = Double(activityEndTime)!
        debugPrint("activityTime = \(activityEndTime)")
        if currentTime > endTime {
            debugPrint("活动已过期 ~")
            return true
        }else {
            debugPrint("活动有效 ~")
            return false
        }
    }
    
    /**
     *  Desc: 获取搜索结果
     *  Param: http://shiyan360.cn/api/vote_search?keyword=66&page=1
     */
    func requestSearchData(urlStr: String, keyword: String, page: Int = 0,completionHandler: @escaping ((_ votes: [VoteListModel]) -> ())) {
        
        var voteList: [VoteListModel]?
        
        let url = urlStr + "?keyword=" + keyword + "&page=\(page)"
        requestDoGet(urlStr: url) { (data, response, error) in
            if error == nil {
                debugPrint("requestSearchData data = \(data)")
                debugPrint("requestSearchData response = \(response)")
                
                //处理服务器返回来的数据
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    if let dict = json as? [String : Any] {
                        if let data = dict["data"] as? [[String : Any]] {
//                            debugPrint("requestVoteList data = \(data)")
                            voteList = [VoteListModel]()
                            for item in data {
                                let vote = VoteListModel(dict: item)
                                voteList?.append(vote)
                            }
                            //回调
                            completionHandler(voteList!)
                        }
                    }
                }catch {
                    debugPrint("catch error = \(error)")
                }
                
            }else{
                debugPrint("error = \(error)")
            }
        }
    }
    
    /**
     *  Desc: 获取投票页数据
     *  Param: http://shiyan360.cn/api/vote_video
     */
    func requestVoteList(urlStr: String, page: Int = 0,completionHandler: @escaping ((_ votes: [VoteListModel]?) -> ())) {
        
        var voteList: [VoteListModel]?
        let url = urlStr + "?page=\(page)"
        requestDoGet(urlStr: url) { (data, response, error) in
            if error == nil {
//                debugPrint("requestVoteList data = \(data)")
//                debugPrint("requestVoteList response = \(response)")
                
                //处理服务器返回来的数据
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    if let dict = json as? [String : Any] {
                        if let data = dict["data"] as? [[String : Any]] {
//                            debugPrint("requestVoteList data = \(data)")
                            voteList = [VoteListModel]()
                            for item in data {
                                let vote = VoteListModel(dict: item)
                                voteList?.append(vote)
                            }
                            //回调
                            completionHandler(voteList)
                        }
                    }
                }catch {
                    debugPrint("catch error = \(error)")
                }
                
            }else{
                debugPrint("error = \(error)")
            }
        }
    }
}
