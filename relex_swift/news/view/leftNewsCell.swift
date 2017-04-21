//
//  leftNewsCell.swift
//  relex_swift
//
//  Created by darren on 16/10/16.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class leftNewsCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var redView: UIView!
    
    var titleStr = String(){
        didSet{
            self.titleLable.text = titleStr
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLable.textColor = APPTextColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.redView.isHidden = false
            self.titleLable.textColor = NavBackGroundColor()
        } else {
            self.redView.isHidden = true
            self.titleLable.textColor = APPTextColor()
        }
    }
    
    static func cellWithTableView(tableView:UITableView) -> leftNewsCell{
        let ID = "cellNewID"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = Bundle.main.loadNibNamed("leftNewsCell", owner: nil, options: nil)?.last as! leftNewsCell?
        }
        return cell! as! leftNewsCell
    }
}
