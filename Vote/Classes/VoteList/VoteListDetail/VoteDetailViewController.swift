//
//  VoteDetailViewController.swift
//  Vote
//
//  Created by mac on 2018/1/5.
//  Copyright © 2018年 modi. All rights reserved.
//

import UIKit
import MediaPlayer
import ZFPlayer
class VoteDetailViewController: UIViewController {

    @objc private func voteBtnDidClick() {
        debugPrint("当前播放时长：\(proLabel?.text)")
        debugPrint("当前滑杆进度：\(videoSlider?.value)")
        //当前票数加1
        var msg = ""
        let text = totalLabel.text!
        let s = "当前票数："
        let totalStr = text.substring(from: s.endIndex)
        if Int(totalStr) == Int((vote?.piao)!)! + 1 {
            msg = "您已经为她投上一票，请勿重复投票 ~ 如果需要再次为她投票，请重新观看该视频 ~ 谢谢"
        }else {
            totalLabel.text = "当前票数：\(Int((vote?.piao)!)! + 1)"
            msg = "投票成功 ~ 您可以跳转到投票页查看她当前的排名情况，是否跳转？"
        }
        
        //弹出一个提示框
        let alert = UIAlertController(title: "温馨提示", message: msg, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            debugPrint(#function)
        }
        let ok = UIAlertAction(title: "确定", style: .destructive) { (action) in
            debugPrint(#function)
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    //播放器控制层
    var proLabel: UILabel?
    var videoSlider: ASValueTrackingSlider?
    //活动是否过期
    var isOverdue = false
    
    var vote: VoteListModel? {
        didSet {
            let url = URL(string: ("http://shiyan360.cn" + (vote?.video_url!)!))
            debugPrint("url ----> \(url?.absoluteString)")
            //基本播放器设置
            let playerModel = ZFPlayerModel()
            playerModel.videoURL = url
            playerModel.fatherView = videoView
            playerModel.title = vote?.name!
            
            playerModel.placeholderImageURLString = "http://shiyan360.cn" + (vote?.img_url_s!)!
            
            //设置控制层View
            let controlView = VotePlayerControlView()
            //运行时获取当前显示时间Label：currentTimeLabel
            proLabel = controlView.value(forKeyPath: "currentTimeLabel") as? UILabel
            debugPrint("proLabel ---> \(proLabel)")
            //运行时获取控制播放滑杆：videoSlider
            videoSlider = controlView.value(forKeyPath: "videoSlider") as? ASValueTrackingSlider
            debugPrint("videoSlider ---> \(videoSlider)")
            
//            videoPlayer.playerModel(playerModel)
            videoPlayer.playerControlView(controlView, playerModel: playerModel)
            //自动播放视频
            videoPlayer.autoPlayTheVideo()
            //设置代理
            videoPlayer.delegate = self
        }
    }
    
    //布局载入时调用
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("活动截止情况：\(isOverdue)")
        if isOverdue {
            voteBtn.setTitle("活动已结束 ~", for: .normal)
            voteBtn.isEnabled = false
            //隐藏票数Label
            totalLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    private func setupUI() {
        view.backgroundColor = UIColor.init(white: 0.93, alpha: 1)
        
        videoView.addSubview(videoPlayer)
        
        view.addSubview(videoView)
        view.addSubview(descLabel)
        view.addSubview(voteBtn)
        view.addSubview(totalLabel)
        
        videoView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(UIScreen.main.bounds.height/3)
        }
        
        videoPlayer.snp.makeConstraints { (make) in
            make.top.equalTo(videoView).offset(10)
            make.left.right.equalTo(videoView)
            // Here a 16:9 aspect ratio, can customize the video aspect ratio
            make.height.equalTo(videoPlayer.snp.width).multipliedBy(9.0/16.0)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(videoView).offset(10)
            make.right.equalTo(videoView).offset(-10)
            make.top.equalTo(videoView.snp.bottom).offset(10)
        }
        
        voteBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(descLabel)
            make.top.equalTo(descLabel.snp.bottom).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
        
        totalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(voteBtn.snp.bottom).offset(10)
            make.centerX.equalTo(voteBtn)
            make.width.equalTo(voteBtn)
            make.height.equalTo(voteBtn)
        }
        
        //数据展示
        descLabel.text = "简介：" + (vote?.remark!)!
        voteBtn.setTitle("为她投票", for: .normal)
        totalLabel.text = "当前票数：" + (vote?.piao!)!
        
        //点击事件
        voteBtn.addTarget(self, action: "voteBtnDidClick", for: .touchUpInside)
    }
    
    //懒加载一个视频播放器
    private lazy var videoPlayer: ZFPlayerView = {
        let video = ZFPlayerView()
//        let playerModel = ZFPlayerModel()
//        video.playerControlView(nil, playerModel: playerModel)
        return video
    }()
    
    private lazy var videoView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.magenta
        return v
    }()
    
    private lazy var descLabel: UILabel = {
        let desc = UILabel()
        desc.textColor = UIColor.brown
        desc.sizeToFit()
        desc.textAlignment = .center
        desc.font = UIFont.systemFont(ofSize: 14)
        desc.numberOfLines = 0
        return desc
    }()
    
    private lazy var totalLabel: UILabel = {
        let total = UILabel()
        total.textColor = UIColor.brown
        total.sizeToFit()
        total.textAlignment = .center
        total.font = UIFont.systemFont(ofSize: 14)
        return total
    }()
    
    private lazy var voteBtn: UIButton = {
        let vote = UIButton()
        vote.setTitleColor(UIColor.white, for: .normal)
        vote.backgroundColor = UIColor.orange
        vote.sizeToFit()
        vote.titleLabel?.textAlignment = .center
        vote.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return vote
    }()
}

extension VoteDetailViewController: ZFPlayerDelegate {
    
}
