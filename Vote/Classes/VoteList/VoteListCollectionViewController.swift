//
//  VoteListCollectionViewController.swift
//  Vote
//
//  Created by mac on 2018/1/4.
//  Copyright © 2018年 modi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class VoteListCollectionViewController: UICollectionViewController {
    var voteList: [VoteListModel]?
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let width = (UIScreen.main.bounds.width-3*10)/2
        let height = (UIScreen.main.bounds.height)/3
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
        
        //添加头部布局
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 120)
        
        setupUI()
        
        //加载测试数据
        initData()
    }
    
    private func setupUI() {
//        collectionView?.backgroundColor = UIColor.init(white: 0.93, alpha: 1)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.addSubview(searchBar)
        collectionView?.addSubview(headerBtn)
        
        searchBar.delegate = self
        
//        searchBar.snp.makeConstraints { (make) in
//            make.left.top.right.equalTo(collectionView!).offset(10)
//            make.height.equalTo(50)
//        }
        
        headerBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo((collectionView?.snp.centerX)!)
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        
    }
    
    private var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.contentMode = .redraw
        search.translatesAutoresizingMaskIntoConstraints = false
//        search.keyboardAppearance = UIKeyboardAppearance.light
//        search.backgroundImage(for: UIBarPosition.top, barMetrics: UIBarMetrics.default)
        search.searchBarStyle = .minimal
//        search.text = "输入关键字搜索"
//        search.placeholder = "出来吗？"
        search.frame = CGRect(x: 0, y: 0, width: 375, height: 56)
//        search.backgroundColor = UIColor.green
        search.showsCancelButton = true
        return search
    }()
    
    private var headerBtn: UIButton = {
        let header = UIButton()
        header.setTitleColor(UIColor.white, for: .normal)
        header.backgroundColor = UIColor.orange
        header.sizeToFit()
        header.titleLabel?.textAlignment = .center
        header.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        header.setTitle("查看排名", for: .normal)
        return header
    }()
    
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(VoteListCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return voteList?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VoteListCollectionViewCell
    
        // Configure the cell
        cell.vote = voteList?[indexPath.item]
        cell.voteBtnDelegate = self
    
        return cell
    }
}

extension VoteListCollectionViewController: VoteBtnDelegate {
    func vote() {
        debugPrint(#function)
        //弹出一个提示框
        let alert = UIAlertController(title: "温馨提示", message: "为她投票前需要观看视频5分钟 ~ 是否继续？", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            debugPrint(#function)
        }
        let ok = UIAlertAction(title: "确定", style: .destructive) { (action) in
            debugPrint(#function)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

extension VoteListCollectionViewController: UISearchBarDelegate {
    
}
