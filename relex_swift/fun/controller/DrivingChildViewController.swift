//
//  DrivingChildViewController.swift
//  relex_swift
//
//  Created by darren on 17/1/3.
//  Copyright © 2017年 darren. All rights reserved.
//

import UIKit
import SDWebImage

class DrivingChildViewController: UIViewController {

    var superVC = DrivingLicenseViewController()
    var model : DrivingModel! {
        didSet{
            self.setupData()
        }
    }
    var dataArr = [String]()
    
    var BeginAlpha:CGFloat = 0.7
    
    var lastImageView = UIImageView()
    var originalFrame:CGRect!
    var scrollView = UIScrollView()
    
    /**tableView*/
    fileprivate lazy var tableView :UITableView = {
        let tableView = UITableView(frame:CGRect(x: 0, y: 0, width: APPW, height: APPH-64), style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    fileprivate lazy var coverView :UIView = {
        let coverView = UIView.init(frame: CGRect(x: APPW, y: 0, width: APPW, height: APPH-64))
        coverView.backgroundColor = UIColor.black
        coverView.alpha = 0.7
        return coverView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(self.clickPan(pan:))))
    }
    
    func clickPan(pan:UIPanGestureRecognizer){
        let point = pan.translation(in: self.view)
        
        let offSetX = point.x   // x<0是左拽
        // 不可省略， 防止右拽时cover的尺寸发生改变
        self.coverView.cl_x = APPW;

        if offSetX<=0 {
            self.view.cl_x = offSetX
            
            // 设置背景的透明度
            let alphe = (-offSetX)/APPW*self.BeginAlpha
            self.coverView.alpha = self.BeginAlpha-alphe;
            
            // 停止拖拽，判断位置
            if (pan.state == UIGestureRecognizerState.ended) {
                if (-offSetX)>APPW*0.5-50 {  // 超过了屏幕的一半
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.view.cl_x = -APPW
                        self.coverView.alpha = 0
                        
                        }, completion: { (true) in
                            self.updataSuperVCRightBtnWith(currentNum: self.superVC.childViewControllers.count-self.view.tag+1)
 
                    })
                    
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.view.cl_x = 0
                        self.coverView.cl_x = APPW
                        
                        self.updataSuperVCRightBtnWith(currentNum: self.superVC.childViewControllers.count-self.view.tag)
                    })
                }
            }
        } else {
            if self.view.tag==(self.superVC.childViewControllers.count-1) {
                return
            }
            let vc = self.superVC.childViewControllers[self.view.tag+1];
            vc.view.cl_x = -(APPW-offSetX)

            // 设置背景的透明度
            self.coverView.alpha = self.BeginAlpha
            self.coverView.cl_x = offSetX
            
            let alphe = (offSetX)/APPW*self.BeginAlpha
            self.coverView.alpha = self.BeginAlpha-alphe
            
            // 停止拖拽，判断位置
            if (pan.state == UIGestureRecognizerState.ended) {
                if (offSetX)>APPW*0.5-50 {  // 超过了屏幕的一半
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        vc.view.cl_x = 0
                         self.coverView.alpha = 0
                        self.coverView.cl_x = APPW
                        self.updataSuperVCRightBtnWith(currentNum: self.superVC.childViewControllers.count-self.view.tag-1)


                        }, completion: { (true) in
                    })
                    
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        vc.view.cl_x = -APPW
                        self.coverView.cl_x = 0
                        self.coverView.alpha = 0
                        self.updataSuperVCRightBtnWith(currentNum: self.superVC.childViewControllers.count-self.view.tag)
                    })
                }
            }
        }
    }
    
    func updataSuperVCRightBtnWith(currentNum:Int){
        let titleStr = String(format: "%ld/%ld", currentNum,self.superVC.view.subviews.count)
        self.superVC.rightBtn?.setTitle(titleStr, for: .normal)
        self.superVC.rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.superVC.rightBtn?.cl_centerY = (self.superVC.navTitleLable?.cl_centerY)!
        self.superVC.rightBtn?.sizeToFit()
    }
}

//处理数据
extension DrivingChildViewController{
    fileprivate func setupData(){
        
        guard let str1 = self.model.item1 else {
            return
        }
        guard let str2 = self.model.item2 else {
            return
        }
        guard let str3 = self.model.item3 else {
            return
        }
        guard let str4 = self.model.item4 else {
            return
        }
        if (str1.characters.count)>0 {
            self.dataArr.append(self.model.item1!)
        }
        if (str2.characters.count)>0 {
            self.dataArr.append(self.model.item2!)
        }
        if (str3.characters.count)>0 {
            self.dataArr.append(self.model.item3!)
        }
        if (str4.characters.count)>0 {
            self.dataArr.append(self.model.item4!)
        }
        
        self.view.addSubview(self.tableView)
        
        self.tableView.tableHeaderView = self.setupHeaderView()
        
        self.view.addSubview(self.coverView)
    }
    
    private func setupHeaderView() -> UIView{
        let header = UIView.init(frame: CGRect(x: 0, y: 0, width: APPW, height: 100))
        
        // 标题
        let titleLable = UILabel.init(frame: CGRect(x: 10, y: 15, width: APPW-20, height: 30))
        titleLable.text = self.model.question
        titleLable.font = UIFont.systemFont(ofSize: 16)
        titleLable.numberOfLines = 0
        titleLable.sizeToFit()
        header.addSubview(titleLable)
        
        if (self.model.url?.characters.count)!>0 {
        
            let iconView = UIImageView.init(frame: CGRect(x: 10, y: titleLable.frame.maxY+20, width: APPW-20, height: 150))
            iconView.contentMode = .scaleAspectFit
            let url = NSURL.init(string: self.model.url!)
            iconView.setImageWith(url as! URL, placeholderImage: UIImage.init(named: "placeHoder1"))
//            iconView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "placeHoder1"))
            header.addSubview(iconView)
            iconView.isUserInteractionEnabled = true
            iconView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.clickImage(ges:))))

            header.cl_height = iconView.frame.maxY+20
            return header
        } else {
            header.cl_height = titleLable.frame.maxY+20

            return header
        }
    }
    
    func clickImage(ges:UITapGestureRecognizer){
       CLImageAmplifyView.setupAmplifyViewWithUITapGestureRecognizer(tap: ges, superView: self.view)
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension DrivingChildViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DriveCell.cellWithTableView(tableView: tableView)
        let imgStr = String.init(format: "choose%d", (indexPath.row+1))
        cell.chooseBtn.setImage(UIImage.init(named: imgStr), for: .normal)
        cell.titleLable.text = self.dataArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Int(self.model.answer!)!==indexPath.row+1 {
            let cell = self.tableView.cellForRow(at: indexPath) as! DriveCell
            cell.chooseBtn.setImage(UIImage.init(named: "ture"), for: .normal)
        } else {
            
            let cell = self.tableView.cellForRow(at: indexPath) as! DriveCell
            cell.chooseBtn.setImage(UIImage.init(named: "false"), for: .normal)
            
            let indepathTrue = NSIndexPath.init(row: Int(self.model.answer!)!-1, section: 0)
            let cell2 = self.tableView.cellForRow(at: indepathTrue as IndexPath) as! DriveCell
            cell2.chooseBtn.setImage(UIImage.init(named: "ture"), for: .normal)
        }
        self.tableView.isUserInteractionEnabled = false

        self.tableView.tableFooterView = self.setupFooterView()
    }
    
    private func setupFooterView() -> UIView{
        let footer = UIView.init(frame: CGRect(x: 0, y: 0, width: APPW, height: 100))
        footer.backgroundColor = UIColor.white
        
        let topView = UIView.init(frame: CGRect(x: 0, y: 80, width: APPW, height: 40))
        let leftLineView = UIView.init(frame: CGRect(x: 0, y: 20, width: APPW*0.5-40, height: 1))
        leftLineView.backgroundColor = UIColor.black
        leftLineView.alpha = 0.1
        topView.addSubview(leftLineView)
        
        let lableTitle = UILabel.init(frame: CGRect(x: leftLineView.cl_width, y: 0, width: 80, height: 40))
        lableTitle.text = "试题详解"
        lableTitle.textAlignment = .center
        topView.addSubview(lableTitle)
        
        let rightLineView = UIView.init(frame: CGRect(x: lableTitle.frame.maxX, y: leftLineView.cl_y, width: leftLineView.cl_width, height: 1))
        rightLineView.backgroundColor = UIColor.black
        rightLineView.alpha = 0.1
        topView.addSubview(rightLineView)
        
        footer.addSubview(topView)
        
        let contentLable = UILabel.init(frame: CGRect(x: 10, y: topView.frame.maxY+10, width: APPW-20, height: 40))
        contentLable.text = self.model.explains
        contentLable.numberOfLines = 0
        let attributedString = NSMutableAttributedString.init(string: contentLable.text!)
        let NSMPStyle = NSMutableParagraphStyle()

        NSMPStyle.lineSpacing = 5
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: NSMPStyle, range: NSMakeRange(0, (contentLable.text?.characters.count)!))
        contentLable.attributedText = attributedString
        contentLable.sizeToFit()
        footer.addSubview(contentLable)

        footer.cl_height = contentLable.frame.maxY+20;
        
        return footer
    }
}

