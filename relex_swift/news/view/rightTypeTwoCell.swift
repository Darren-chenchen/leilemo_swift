//
//  rightTypeTwoCell.swift
//  relex_swift
//
//  Created by Darren on 16/10/19.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class rightTypeTwoCell: UITableViewCell {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLanle: UILabel!
    
    @IBOutlet weak var playImage: UIImageView!
    
    var videoStr = ""

    var funneyModel:FunneyModel = FunneyModel(dict:[:]){
        didSet{
            
            let array = funneyModel.videoList
            let dataDic = array?.lastObject
            guard let resultData = dataDic else {
                return
            }
            let model = VidioListModel(dict: (resultData as? [String:AnyObject])!)
            self.titleLanle.text = model.title
            
            let url = NSURL.init(string: model.image!)
            guard let imageurl = url else {
                return
            }
            self.iconView.setImageWith(imageurl as URL, placeholderImage: UIImage(named:"placeHoder1"))

        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bottonV = cellBottomView.show()
        bottonV.frame = self.bottomView.bounds
        self.bottomView.addSubview(bottonV)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func cellWithTableView(tableView:UITableView) -> rightTypeTwoCell{
        let ID = "rightTypeTwoCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = Bundle.main.loadNibNamed("rightTypeTwoCell", owner: nil, options: nil)?.last as! rightTypeTwoCell?
        }
        cell?.selectionStyle = .none
        return cell! as! rightTypeTwoCell
    }
}
