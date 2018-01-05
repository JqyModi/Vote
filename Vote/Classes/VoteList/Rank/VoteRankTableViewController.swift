//
//  VoteListTableViewController.swift
//  Vote
//
//  Created by mac on 2018/1/3.
//  Copyright © 2018年 modi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"
class VoteRankTableViewController: UITableViewController {

    var voteList: [VoteListModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        debugPrint("VoteListModel.description() -----> \(VoteListModel(dict: nil).description)")
        
        initData()
        setupUI()
        
    }
    
    private func initData() {
        //获取数据
        let test = Bundle.main.url(forResource: "test", withExtension: "json")
        debugPrint("test ----> \(test!)")
        do{
            let json = try String(contentsOf: test!)
            debugPrint("json ----> \(json)")
            let voteLists = try JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSArray
            debugPrint("voteLists ----> \(voteLists?.description)")
            voteList = [VoteListModel]()
            for item in voteLists! {
                if let dict = item as? [String:Any] {
                    let vote = VoteListModel(dict: dict)
                    voteList?.append(vote)
                }
            }
            
        }catch {
            debugPrint("error ----> \(error)")
        }
    }
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.init(white: 0.93, alpha: 1)
        tableView.register(VoteRankTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return voteList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! VoteRankTableViewCell

        // Configure the cell...
        cell.vote = voteList?[indexPath.row]
        cell.item = indexPath.row

        return cell
    }

}
