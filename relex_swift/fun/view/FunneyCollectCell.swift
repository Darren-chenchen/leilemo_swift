//
//  FunneyCollectCell.swift
//  relex_swift
//
//  Created by darren on 17/1/20.
//  Copyright © 2017年 darren. All rights reserved.
//

import UIKit
import RealmSwift

typealias clickCollectionDelectBtnClose = (Realm_FunModel) ->Void

class FunneyCollectCell: UITableViewCell {

    let realm = try! Realm()
    
    var clickCollectionDelectBtn:clickCollectionDelectBtnClose? = nil
    

    var model = Realm_FunModel(){
        didSet{
            self.contentLable.text = model.content
            self.collectTimerLable.text = "收藏日期:"+model.collectTimer
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBOutlet weak var contentLable: UILabel!
    @IBOutlet weak var collectTimerLable: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    static func cellWithTableView(tableView:UITableView) -> FunneyCollectCell{
        let ID = "FunneyCollectCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = Bundle.main.loadNibNamed("FunneyCollectCell", owner: nil, options: nil)?.last as! FunneyCollectCell?
        }
        cell?.selectionStyle = .none
        return cell! as! FunneyCollectCell
    }


    @IBAction func clickDelectBtn(_ sender: AnyObject) {
        
        if self.clickCollectionDelectBtn != nil {
            self.clickCollectionDelectBtn!(self.model)
        }
    }
}
