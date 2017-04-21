//
//  rightTypeOneCell.swift
//  relex_swift
//
//  Created by darren on 16/10/16.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
import Alamofire

class rightTypeOneCell: UITableViewCell {

    @IBOutlet weak var imageHYS: NSLayoutConstraint!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    
    @IBOutlet weak var bottomView: UIView!
    
    // 科技新闻
    var techModel:technologyModel = technologyModel(dict:[:]){
        didSet{
            self.titleLable.text = techModel.stitle as! String?
            
            let url = NSURL.init(string: techModel.imgsrc2!)
            
            guard let imageurl = url else {
                return
            }
            self.topImageView.setImageWith(imageurl as URL, placeholderImage: UIImage(named:"placeHoder1"))
            self.imageHYS.constant = 250
        }
    }
    
    // NBA
    var NBAModel:nbaModel = nbaModel(dict:[:]){
        didSet{
            self.titleLable.text = NBAModel.stitle
            
            guard let imageDict = NBAModel.img else {
                self.topImageView.image = UIImage(named: "placehoder3")
                self.imageHYS.constant = 200
                return
            }
            let url = NSURL.init(string: imageDict["u"] as! String)
            
            guard let imageurl = url else {
                return
            }
            self.topImageView.setImageWith(imageurl as URL, placeholderImage: UIImage(named:"placeHoder1"))
            
            let height:CGFloat = NBAModel.img?["h"] as! CGFloat
            let width:CGFloat = NBAModel.img?["w"] as! CGFloat

            let BILI = height/width
            self.imageHYS.constant = APPW*BILI
        }
    }
    
    // 汽车
    var carModel:CarModel = CarModel(dict:[:]){
        didSet{
            self.titleLable.text = carModel.title
            
            let url = NSURL.init(string: carModel.picCover!)
            
            guard let imageurl = url else {
                return
            }
            self.topImageView.setImageWith(imageurl as URL, placeholderImage: UIImage(named:"placeHoder1"))
            
            self.imageHYS.constant = 250
        }
    }



    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLable.textColor = APPTextColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func cellWithTableView(tableView:UITableView) -> rightTypeOneCell{
        let ID = "cellTechID"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = Bundle.main.loadNibNamed("rightTypeOneCell", owner: nil, options: nil)?.last as! rightTypeOneCell?
        }
        return cell! as! rightTypeOneCell
    }

    
}
