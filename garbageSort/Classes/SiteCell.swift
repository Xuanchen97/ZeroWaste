//
//  SiteCell.swift
//  XuanchenLiu_FinalExam
//
//  Created by Xuanchen Liu on 2020-04-06.
//  Copyright © 2020 Xuanchen Liu. All rights reserved.
//
import UIKit

class SiteCell: UITableViewCell {
    
    // step 11 - define 2 labels and an image view for our custom cell
    let primaryLabel = UILabel()
    let secondaryLabel = UILabel()
    let thirdLabel = UILabel()
    let fourthLabel = UILabel()
    let fifthLabel = UILabel()
    let sixthLabel = UILabel()
    let seventhLabel = UILabel()
    let eighthLabel = UILabel()
    let myImageView = UIImageView()
    
    // step 11b - override the following constructor
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        primaryLabel.textAlignment = NSTextAlignment.left
        primaryLabel.font = UIFont.boldSystemFont(ofSize: 30)
        primaryLabel.backgroundColor = UIColor.clear
        primaryLabel.textColor = UIColor.black
    
        secondaryLabel.textAlignment = NSTextAlignment.left
        secondaryLabel.font = UIFont.boldSystemFont(ofSize: 16)
        secondaryLabel.backgroundColor = UIColor.clear
        secondaryLabel.textColor = UIColor.blue
   
        thirdLabel.textAlignment = NSTextAlignment.left
        thirdLabel.font = UIFont.boldSystemFont(ofSize: 16)
        thirdLabel.backgroundColor = UIColor.clear
        thirdLabel.textColor = UIColor.black
        
        fourthLabel.textAlignment = NSTextAlignment.left
        fourthLabel.font = UIFont.boldSystemFont(ofSize: 16)
        fourthLabel.backgroundColor = UIColor.clear
        fourthLabel.textColor = UIColor.black
        
        
        fifthLabel.textAlignment = NSTextAlignment.left
        fifthLabel.font = UIFont.boldSystemFont(ofSize: 16)
        fifthLabel.backgroundColor = UIColor.clear
        fifthLabel.textColor = UIColor.black
        
        
        sixthLabel.textAlignment = NSTextAlignment.left
        sixthLabel.font = UIFont.boldSystemFont(ofSize: 16)
        sixthLabel.backgroundColor = UIColor.clear
        sixthLabel.textColor = UIColor.black
        
        
        seventhLabel.textAlignment = NSTextAlignment.left
        seventhLabel.font = UIFont.boldSystemFont(ofSize: 16)
        seventhLabel.backgroundColor = UIColor.clear
        seventhLabel.textColor = UIColor.black
        
        eighthLabel.textAlignment = NSTextAlignment.left
        eighthLabel.font = UIFont.boldSystemFont(ofSize: 16)
        eighthLabel.backgroundColor = UIColor.clear
        eighthLabel.textColor = UIColor.black
        
        
        // step 11e - no configuring of myImageView needed, instead add all 3 items manually as below
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(primaryLabel)
        contentView.addSubview(secondaryLabel)
        contentView.addSubview(thirdLabel)
        contentView.addSubview(fourthLabel)
        contentView.addSubview(fifthLabel)
        contentView.addSubview(sixthLabel)
        contentView.addSubview(seventhLabel)
        contentView.addSubview(eighthLabel)
        contentView.addSubview(myImageView)
        
        
    }
    
    // step 11f - override base constructor to avoid compile error
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // step 11g - define size and location of all 3 items as below
    // return to ChooseSiteViewController.swift
    override func layoutSubviews() {
        
        var f = CGRect(x: 100, y: 5, width: 460, height: 30)
        primaryLabel.frame = f
        
        f = CGRect(x: 100, y: 40, width: 460, height: 20)
        secondaryLabel.frame = f
        
        f = CGRect(x: 100, y: 65, width: 460, height: 20)
        thirdLabel.frame = f
        
        f = CGRect(x: 100, y: 90, width: 460, height: 20)
        fourthLabel.frame = f
        
        f = CGRect(x: 100, y: 115, width: 460, height: 20)
       fifthLabel.frame = f
        
        f = CGRect(x: 100, y: 140, width: 460, height: 20)
        sixthLabel.frame = f
        
        f = CGRect(x: 100, y: 165, width: 460, height: 20)
        seventhLabel.frame = f
        
        f = CGRect(x: 100, y: 190, width: 460, height: 20)
        eighthLabel.frame = f
        
        f = CGRect(x: 5, y: 5, width: 45, height: 45)
        myImageView.frame = f
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
