//
//  VoteListCollectionViewCell.swift
//  Vote
//
//  Created by mac on 2018/1/4.
//  Copyright © 2018年 modi. All rights reserved.
//

import UIKit
import SnapKit

protocol VoteBtnDelegate: NSObjectProtocol {
    func vote()
}

class VoteListCollectionViewCell: UICollectionViewCell {
    
    @objc private func voteBtnDidClick() {
        debugPrint(#function)
        voteBtnDelegate?.vote()
    }
    
    var vote: VoteListModel? {
        didSet {
            setupUI()
        }
    }
    
    var voteBtnDelegate: VoteBtnDelegate?
    
    private func setupUI() {
        //添加视图
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(voteBtn)
        contentView.addSubview(totalLabel)
        
        //添加约束
        
        totalLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.centerX.equalTo(contentView.snp.centerX)
            make.left.right.equalTo(contentView)
            make.height.equalTo(20)
        }
        
        voteBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(totalLabel.snp.top).offset(-10)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(totalLabel)
            make.height.equalTo(totalLabel)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(voteBtn.snp.top).offset(-10)
            make.left.right.equalTo(contentView)
            make.height.equalTo(20)
        }
        
        coverImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(titleLabel.snp.top).offset(-10)
            make.top.equalTo(contentView)
            make.left.right.equalTo(contentView)
        }
        
        coverImageView.sd_setImage(with: URL(string: (vote?.image)!), completed: nil)
        titleLabel.text = vote?.title
        totalLabel.text = "当前票数：" + (vote?.total!)!
        voteBtn.setTitle("投票", for: .normal)
        
        //添加按钮点击事件
        voteBtn.addTarget(self, action: "voteBtnDidClick", for: .touchUpInside)
    }
    
    
    private var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGray
        imageView.sizeToFit()
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = UIColor.brown
        title.sizeToFit()
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 15)
        return title
    }()
    
    private var descLabel: UILabel = {
        let desc = UILabel()
        desc.textColor = UIColor.brown
        desc.sizeToFit()
        desc.textAlignment = .center
        desc.font = UIFont.systemFont(ofSize: 14)
        return desc
    }()
    
    private var totalLabel: UILabel = {
        let total = UILabel()
        total.textColor = UIColor.brown
        total.sizeToFit()
        total.textAlignment = .center
        total.font = UIFont.systemFont(ofSize: 14)
        return total
    }()
    
    private var voteBtn: UIButton = {
        let vote = UIButton()
        vote.setTitleColor(UIColor.white, for: .normal)
        vote.backgroundColor = UIColor.orange
        vote.sizeToFit()
        vote.titleLabel?.textAlignment = .center
        vote.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return vote
    }()
}
