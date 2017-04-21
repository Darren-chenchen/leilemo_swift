//
//  settingCell.swift
//  relex_swift
//
//  Created by darren on 16/12/7.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class settingCell: UICollectionViewCell {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
    }

}
