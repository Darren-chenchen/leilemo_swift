//
//  DriveCell.swift
//  relex_swift
//
//  Created by darren on 17/1/3.
//  Copyright © 2017年 darren. All rights reserved.
//

import UIKit

class DriveCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var chooseBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func cellWithTableView(tableView:UITableView) -> DriveCell{
        let ID = "DriveCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = Bundle.main.loadNibNamed("DriveCell", owner: nil, options: nil)?.last as! DriveCell?
        }
        cell?.selectionStyle = .blue
        return cell! as! DriveCell
    }
}
