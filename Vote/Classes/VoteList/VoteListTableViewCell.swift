//
//  VoteListTableViewCell.swift
//  Vote
//
//  Created by mac on 2018/1/4.
//  Copyright © 2018年 modi. All rights reserved.
//

import UIKit
import SDWebImage

class VoteListTableViewCell: UITableViewCell {

    var vote: VoteListModel? {
        didSet {
            setupUI()
        }
    }
    
    private func setupUI() {
        //添加视图
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(voteBtn)
        
        //添加约束
//        coverImageView.sd_layout().centerXEqualToView(self.contentView)
//        coverImageView.sd_layout().centerYEqualToView(self.contentView)
//        coverImageView.sd_layout().spaceToSuperView(UIEdgeInsetsMake(10, 10, 10, 10))
    }
    
    
    private var coverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGray
        imageView.sizeToFit()
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = UIColor.white
        title.sizeToFit()
        title.font = UIFont.systemFont(ofSize: 15)
        return title
    }()
    
    private var descLabel: UILabel = {
        let desc = UILabel()
        desc.textColor = UIColor.white
        desc.sizeToFit()
        desc.font = UIFont.systemFont(ofSize: 14)
        return desc
    }()
    
    private var voteBtn: UIButton = {
        let vote = UIButton()
        vote.setTitleColor(UIColor.white, for: .normal)
        vote.backgroundColor = UIColor.orange
        vote.sizeToFit()
        vote.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return vote
    }()
}
