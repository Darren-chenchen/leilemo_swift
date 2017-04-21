//
//  gameListCell.swift
//  relex_swift
//
//  Created by Darren on 16/10/23.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class gameListCell: UITableViewCell {

    @IBOutlet weak var timerLable: UILabel!
    @IBOutlet weak var durationLable: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    var model:DetailModel = DetailModel(dict:[:]){
        didSet{
            
            self.titleLable.text = model.title
            self.durationLable.text = model.duration
            self.timerLable.text = model.created_at
            
            let url = NSURL.init(string: model.img!)
            guard let imageurl = url else {
                return
            }
            self.iconView.setImageWith(imageurl as URL, placeholderImage: UIImage(named:"placeHoder1"))
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.durationLable.textColor = UIColor.lightGray
        self.timerLable.textColor = UIColor.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    static func cellWithTableView(tableView:UITableView) -> gameListCell{
        let ID = "gameListCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = Bundle.main.loadNibNamed("gameListCell", owner: nil, options: nil)?.last as! gameListCell?
        }
        return cell! as! gameListCell
    }

}
