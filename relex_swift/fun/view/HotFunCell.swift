//
//  HotFunCell.swift
//  relex_swift
//
//  Created by darren on 16/10/16.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
import RealmSwift

class HotFunCell: UITableViewCell {

    @IBOutlet weak var contentLable: UILabel!
    
    @IBOutlet weak var bottomView: cellBottomView!
    
    let realm = try! Realm()
    
   // 流行笑话
    var model:hotFunModel = hotFunModel(dict:[:]){
        didSet{
            self.contentLable.text = model.content
            let NSMAString = NSMutableAttributedString.init(string: self.contentLable.text!)
            let NSMPStyle = NSMutableParagraphStyle()
            //设置行间距为25
            NSMPStyle.lineSpacing = 8
            NSMAString.addAttribute(NSParagraphStyleAttributeName, value: NSMPStyle, range: NSMakeRange(0, (self.contentLable.text?.characters.count)!))
            self.contentLable.attributedText = NSMAString
        }
    }
    // 经典笑话
    var classessModel:classessFunModel = classessFunModel(dict:[:]){
        didSet{
            self.contentLable.text = classessModel.text
            
            let NSMAString = NSMutableAttributedString.init(string: self.contentLable.text!)
            let NSMPStyle = NSMutableParagraphStyle()
            //设置行间距为25
            NSMPStyle.lineSpacing = 8
            NSMAString.addAttribute(NSParagraphStyleAttributeName, value: NSMPStyle, range: NSMakeRange(0, (self.contentLable.text?.characters.count)!))
            self.contentLable.attributedText = NSMAString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentLable.textColor = APPTextColor()
        self.contentLable.font = UIFont.systemFont(ofSize: 15)
        
        let bottonV = cellBottomView.show()
        bottonV.clickShareButtonClosure = { () in
            let win = UIApplication.shared.keyWindow
            let shareView = CLShareView()
            if (self.model.content != nil) { // 开心一刻
                shareView.shareTitle = "累了麽致敬swift3.0"
                shareView.shareUrlStr = "itms-apps://itunes.apple.com/app/id1070843107"
                shareView.shareContent = self.model.content!
                shareView.shareImageStr = "icon"
            }
            win?.addSubview(shareView)
        }
        bottonV.frame = self.bottomView.bounds
        self.bottomView.addSubview(bottonV)
        bottonV.clickFavClosure = { () in
            try! self.realm.write {
                let model = Realm_FunModel()
                model.content = self.contentLable.text!
                
                let date = NSDate()
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
                let strNowTime = timeFormatter.string(from: date as Date) as String
                model.collectTimer = strNowTime;
                
                self.realm.add(model)
                
                CLHUDV2.cl_showSuccessTextAndDuration(text: "已收藏", duration: 1)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func cellWithTableView(tableView:UITableView) -> HotFunCell{
        let ID = "cellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = Bundle.main.loadNibNamed("HotFunCell", owner: nil, options: nil)?.last as! HotFunCell?
        }
        return cell! as! HotFunCell
    }
    
}
