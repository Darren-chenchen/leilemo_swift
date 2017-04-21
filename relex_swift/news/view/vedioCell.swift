//
//  rightTypeTwoCell.swift
//  relex_swift
//
//  Created by Darren on 16/10/19.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
import AVFoundation

typealias clickPlayerImageViewClosure = (String) ->Void

class vedioCell: UITableViewCell {

    var clickImageClosure:clickPlayerImageViewClosure? = nil
    
    var arraymodel = [FunneyModel]()
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLanle: UILabel!
    
    @IBOutlet weak var playImage: UIImageView!
    
    @IBOutlet weak var blackView: UIView!
    var videoStr = ""
    
    var avPlayer:AVPlayer! = nil
    
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

            if funneyModel.isPlaying {
                self.blackView.layer.addSublayer(vedioTools.shareSingleOne.playLary)
                self.playImage.isHidden = true
                self.blackView.isHidden = false
            } else {
                self.playImage.isHidden = false
                self.blackView.isHidden = true
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bottonV = cellBottomView.show()
        bottonV.frame = self.bottomView.bounds
        self.bottomView.addSubview(bottonV)
        
        self.playImage.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(vedioCell.clickPlayeImageView)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(vedioCell.playItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    func playItemDidReachEnd() {
        self.playImage.isHidden = false
        self.funneyModel.isPlaying = false
        self.blackView.isHidden = true
        vedioTools.shareSingleOne.playLary.removeFromSuperlayer()
    }
    deinit{
        CLNotificationCenter.removeObserver(self)
    }
    func clickPlayeImageView() {
        
        self.funneyModel.isPlaying = true
        
        let model = self.funneyModel 
        let array = model.videoList
        let dataDic = array?.lastObject

        guard let resultData = dataDic else {
            return
        }
        let modelVideo = VidioListModel(dict: (resultData as? [String:AnyObject])!)
        let memerDict = modelVideo.memberItem
        
        let idStr:String = memerDict!.value(forKey: "guid") as! String
        let urlStr = "http://vcsp.ifeng.com/vcsp/appData/getGuidRelativeVideoList.do?pageSize=20&guid="+idStr
        
        let dict = [String:AnyObject]()
        NetTools.shareInstance.getHomeInfo(requestUrl: urlStr, parameters: dict) { (result, error) in
            
            if error != nil {
                return
            }
            guard let resultArray2 = result else {
                return
            }
            let dataDic2:NSDictionary = (resultArray2 as? NSDictionary)!
            let array2:NSArray = dataDic2.value(forKey: "guidRelativeVideoInfo") as! NSArray
            let dict = array2[0] as! NSDictionary
            let arr:NSArray = dict.value(forKey: "files") as! NSArray
            let dict2 = arr[0] as! NSDictionary
            self.videoStr = dict2.value(forKey: "mediaUrl") as! String
            print("===============================\(self.videoStr)")
            self.openUrl(url: self.videoStr)

        }
    }
    
    static func cellWithTableView(tableView:UITableView) -> vedioCell{
        let ID = "vedioCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = Bundle.main.loadNibNamed("vedioCell", owner: nil, options: nil)?.last as! vedioCell?
        }
        cell?.selectionStyle = .none
        return cell! as! vedioCell
    }
    
    //播放VIODE
    func openUrl(url:String){
        for model:FunneyModel in self.arraymodel {
            model.isPlaying = false   //置于未播放
        }
        self.funneyModel.isPlaying = true  //置于播放
        vedioTools.shareSingleOne.playUrl(url: url, view: self.blackView)
        self.playImage.isHidden = true
        self.blackView.isHidden = false
        
        self.clickImageClosure!("")
    }

}


