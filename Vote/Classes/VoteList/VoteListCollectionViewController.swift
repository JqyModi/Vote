//
//  VoteListCollectionViewController.swift
//  Vote
//
//  Created by mac on 2018/1/4.
//  Copyright © 2018年 modi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
//FooterView
private let footerViewIdentifier = "FooterView"

private struct Config {
    static let count = 2
    static let itemWidth = (UIScreen.main.bounds.width-CGFloat((count-1)*10)) / CGFloat(count)
    static let itemHeight = (UIScreen.main.bounds.height) / CGFloat((count + 1))
}

class VoteListCollectionViewController: UICollectionViewController {
    
    @objc private func headerBtnDidClick() {
        debugPrint(#function)
        
        let detail = VoteRankTableViewController()
        detail.title = "排名"
        detail.voteList = voteList
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    var voteList: [VoteListModel]?
    
    var currentPage = 0
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: Config.itemWidth, height: Config.itemHeight)
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
        
        //添加头部布局
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 120)
        //添加尾部布局
        layout.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
        
        setupUI()
        
        //加载测试数据
        loadData()
        
    }
    
    private func setupUI() {
        collectionView?.backgroundColor = UIColor.init(white: 0.93, alpha: 1)
        //加入上拉加载视图：删除不行？
        collectionView?.addSubview(indicatorView)
        
        //加入下拉刷新
        collectionView?.addSubview(refresh)
        
        collectionView?.addSubview(headerBtn)
        collectionView?.addSubview(searchBar)
        
        headerBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo((collectionView?.snp.centerX)!)
            make.top.equalTo(collectionView!).offset(80)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        
        searchBar.snp.makeConstraints { (make) in
            make.centerX.equalTo(collectionView!)
            make.bottom.equalTo(headerBtn).offset(-46)
            make.height.equalTo(56)
            //设置宽度：否则无法显示
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        //
        searchBar.delegate = self
        //
        headerBtn.addTarget(self, action: "headerBtnDidClick", for: .touchUpInside)
        //下拉刷新监听
        refresh.addTarget(self, action: "loadData", for: .valueChanged)
    }
    
    //懒加载
    
    //上拉加载
    private lazy var indicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.color = UIColor.randomColor
        //        aiv.hidesWhenStopped = true
        aiv.activityIndicatorViewStyle = .gray
        return aiv
    }()
    
    private lazy var testView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.randomColor
        return v
    }()
    
    //下拉刷新
    private lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = UIColor.randomColor
        refresh.backgroundColor = UIColor.randomColor
        return refresh
    }()
    
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.contentMode = .redraw
        search.translatesAutoresizingMaskIntoConstraints = false
        search.keyboardAppearance = UIKeyboardAppearance.light
        search.searchBarStyle = .minimal
        search.placeholder = "输入关键字搜索"
//        search.backgroundColor = UIColor.green
        search.text = "测试"
        search.showsCancelButton = true
        search.sizeToFit()
        return search
    }()
    
    private lazy var headerBtn: UIButton = {
        let header = UIButton()
        header.setTitleColor(UIColor.white, for: .normal)
        header.backgroundColor = UIColor.orange
        header.sizeToFit()
        header.titleLabel?.textAlignment = .center
        header.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        header.setTitle("查看排名", for: .normal)
        return header
    }()
    
    @objc private func loadData() {
        /**
        //获取本地测试数据
        let test = Bundle.main.url(forResource: "test", withExtension: "json")
//        debugPrint("test ----> \(test!)")
        do{
            let json = try String(contentsOf: test!)
//            debugPrint("json ----> \(json)")
            let voteLists = try JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSArray
//            debugPrint("voteLists ----> \(voteLists?.description)")
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
        */
        //联网获取数据源
        let url = "http://shiyan360.cn/api/vote_video"
        //内部引用self：会造成循环引用 加上weak
        NetworkTools.sharedSingleton.requestVoteList(urlStr: url) { [weak self] (votes) in
            self?.voteList?.removeAll()
            self?.voteList = votes
            
            debugPrint("currentThread 1 ----> \(Thread.current)")
            self?.collectionView?.reloadData()
            
            //菊花停止转动
            if (self?.refresh.isRefreshing)! {
                self?.refresh.endRefreshing()
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(VoteListCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        //注册尾部视图
        self.collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewIdentifier)
        
        //子线程获取活动是否过期
        NetworkTools.sharedSingleton.isOverdue { (isOver) in
            let standard = UserDefaults.standard
            standard.set(isOver, forKey: "isOverdue")
            standard.synchronize()
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return voteList?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VoteListCollectionViewCell
    
        // Configure the cell
        cell.vote = voteList?[indexPath.item]
        cell.voteBtnDelegate = self
        
        debugPrint("indexPath 1 ------> \(indexPath)")
        //设置上拉加载数据操作：当Cell是上拉加载布局Cell时且菊花没有滚动状态下开始上拉加载数据
//        if indexPath.row == statuses.count - 1 && !indicatorView.isAnimating {
//            //开始上拉加载
//            indicatorView.startAnimating()
//            loadData()
//            debugPrint("开始加载更多数据")
//        }
        return cell
    }
}

extension VoteListCollectionViewController: VoteBtnDelegate {
    func vote(cell: VoteListCollectionViewCell) {
        debugPrint(#function)
        //弹出一个提示框
        let alert = UIAlertController(title: "温馨提示", message: "为她投票前需要观看视频5分钟 ~ 是否继续？", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            debugPrint(#function)
        }
        let ok = UIAlertAction(title: "确定", style: .destructive) { (action) in
            debugPrint(#function)
            let detail = VoteDetailViewController()
            let nav = UINavigationController(rootViewController: detail)
            detail.vote = cell.vote
            detail.title = "投票详情页"
            //将活动过期情况传递过去
            let standard = UserDefaults.standard
            if let isOver = standard.value(forKey: "isOverdue") as? Bool {
                detail.isOverdue = isOver
            }
            self.navigationController?.pushViewController(detail, animated: true)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

extension VoteListCollectionViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        debugPrint("searchBar textDidChange: \(searchText)")
//    }
    
    /**
     *  Desc: 按下键盘上搜索Search
     *  Param:
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //获取到关键字
        if let keyword = searchBar.text {
            //发送搜索请求数据
            //联网获取数据源
            let url = "http://shiyan360.cn/api/vote_search"
            //内部引用self：会造成循环引用 加上weak
            NetworkTools.sharedSingleton.requestSearchData(urlStr: url, keyword: keyword, completionHandler: { [weak self] (votes) in
                self?.voteList?.removeAll()
                self?.voteList = votes
                
                debugPrint("currentThread 2 ----> \(Thread.current)")
                //需要在主线程更新UI
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            })
        }
        
    }
    
    /**
     *  Desc: 用户点击取消Cancel
     *  Param:
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //隐藏键盘
        searchBar.resignFirstResponder()
        //将数据源替换成正常状态
        //联网获取数据源
        let url = "http://shiyan360.cn/api/vote_video"
        //内部引用self：会造成循环引用 加上weak
        NetworkTools.sharedSingleton.requestVoteList(urlStr: url) { [weak self] (votes) in
            self?.voteList?.removeAll()
            self?.voteList = votes
            
            debugPrint("currentThread 3 ----> \(Thread.current)")
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
    }
}

extension VoteListCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        debugPrint("indexPath 2 ------> \(indexPath)")
        
        let footView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewIdentifier, for: indexPath)
        footView.backgroundColor = UIColor.randomColor
        //添加上拉加载视图
        footView.addSubview(indicatorView)
        //添加约束
        indicatorView.snp.makeConstraints { (make) in
            make.edges.equalTo(footView)
        }
        indicatorView.startAnimating()
        return footView
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        <#code#>
    }
    override func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        <#code#>
    }
    
}
