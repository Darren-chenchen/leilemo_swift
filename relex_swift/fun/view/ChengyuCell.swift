//
//  ChengyuCell.swift
//  relex_swift
//
//  Created by darren on 16/12/20.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class ChengyuCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func cellWithTableView(tableView:UITableView) -> ChengyuCell{
        let ID = "ChengyuCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = Bundle.main.loadNibNamed("ChengyuCell", owner: nil, options: nil)?.last as! ChengyuCell?
        }
        cell?.selectionStyle = .none
        return cell! as! ChengyuCell
    }
    

}
