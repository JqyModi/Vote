//
//  VoteListTableViewCell.swift
//  Vote
//
//  Created by mac on 2018/1/4.
//  Copyright © 2018年 modi. All rights reserved.
//

import UIKit
import SDWebImage

class VoteRankTableViewCell: UITableViewCell {

    var vote: VoteListModel? {
        didSet {
            setupUI()
        }
    }
    
    var item: Int = 0 {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        //判断是否是前三个
        var imageName = ""
        if item == 0 {
            imageName = "rank_1"
            setAwardUI(imageName: imageName, color: UIColor.red)
        }else if item == 1 {
            imageName = "rank_2"
            setAwardUI(imageName: imageName, color: UIColor.green)
        }else if item == 2 {
            imageName = "rank_3"
            setAwardUI(imageName: imageName, color: UIColor.blue)
        }else {
            coverImageView.isHidden = true
        }
        
    }
    
    private func setAwardUI(imageName: String, color: UIColor) {
        titleLabel.textColor = color
        coverImageView.image = UIImage(named: imageName)
    }
    
    private func setupUI() {
        //添加视图
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(totalLabel)
        
        //添加约束
        coverImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(contentView).offset(10)
            make.width.height.equalTo(30)
        }
        
        totalLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-10)
            make.centerY.equalTo(coverImageView)
            make.width.equalTo(50)
            make.height.equalTo(coverImageView)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(coverImageView.snp.right).offset(10)
            make.centerY.equalTo(coverImageView)
            make.right.equalTo(totalLabel).offset(-10)
            make.height.equalTo(totalLabel)
        }
        
        //数据展示
        titleLabel.text = vote?.name!
        totalLabel.text = vote?.piao!
    }
    
    
    private lazy var coverImageView: UIImageView = {
       let imageView = UIImageView()
//        imageView.backgroundColor = UIColor.lightGray
        imageView.sizeToFit()
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = UIColor.brown
        title.sizeToFit()
        title.font = UIFont.systemFont(ofSize: 15)
        return title
    }()
    
    private lazy var totalLabel: UILabel = {
        let total = UILabel()
        total.textColor = UIColor.brown
        total.sizeToFit()
        total.font = UIFont.systemFont(ofSize: 14)
        return total
    }()
}
