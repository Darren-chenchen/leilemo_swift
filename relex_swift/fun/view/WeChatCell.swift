//
//  WeChatCell.swift
//  relex_swift
//
//  Created by darren on 16/12/20.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class WeChatCell: UITableViewCell {

    @IBOutlet weak var mainTitleLable: UILabel!
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    
    var model:WeChatModel = WeChatModel(dict:[:]){
        didSet{
            self.titleLable.text = "来源:"+model.source!
            let url = NSURL.init(string: model.firstImg!)
            
            guard let imageurl = url else {
                return
            }
            self.bgView.setImageWith(imageurl as URL, placeholderImage: UIImage(named:"placeHoder1"))
            self.iconView.setImageWith(imageurl as URL, placeholderImage: UIImage(named:"placeHoder1"))

            self.mainTitleLable.text = "   "+model.title!
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        CLViewsBorder(self.iconView, borderWidth: 0, borderColor: NavTitleColor(), cornerRadius: 12.5)
        
        self.mainTitleLable.backgroundColor = UIColor(white: 0, alpha: 0.7)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func cellWithTableView(tableView:UITableView) -> WeChatCell{
        let ID = "WeChatCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = Bundle.main.loadNibNamed("WeChatCell", owner: nil, options: nil)?.last as! WeChatCell?
        }
        cell?.selectionStyle = .none
        return cell! as! WeChatCell
    }
    
    

}
