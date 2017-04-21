//
//  DriveChooseCell.swift
//  relex_swift
//
//  Created by darren on 16/12/30.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class DriveChooseCell: UICollectionViewCell {

    @IBOutlet weak var cellButton: UIButton!
    
   override var isSelected:Bool {
        didSet{
            if isSelected {
                self.cellButton.backgroundColor = NavBackGroundColor()
                self.cellButton.setTitleColor(UIColor.white, for: .normal)
            } else {
                self.cellButton.setTitleColor(APPTextColor(), for: .normal)
                self.cellButton.backgroundColor = UIColor.white
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CLViewsBorder(self.cellButton, borderWidth: 1, borderColor: UIColor.lightGray, cornerRadius: 3)
        self.cellButton.backgroundColor = UIColor.white
        self.cellButton.setTitleColor(APPTextColor(), for: .normal)
        self.cellButton.isUserInteractionEnabled = false
    }
}
