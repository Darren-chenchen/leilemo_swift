//
//  ChengYuModel.swift
//  relex_swift
//
//  Created by darren on 16/12/20.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class ChengYuModel: NSObject {
    var pinyin: String?
    var chengyujs: String?
    var from_: String?
    var yufa: String?
    var tongyi: NSArray?
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        pinyin = dict["pinyin"] as? String  ?? "暂无"
        chengyujs = dict["chengyujs"] as? String ?? "暂无"
        from_ = dict["from_"] as? String ?? "暂无"
        yufa = dict["yufa"] as? String ?? "暂无"
        tongyi = dict["tongyi"] as? NSArray  ?? ["暂无"]
    }

//    "result": {
//    "bushou": "禾",
//    "head": "积",
//    "pinyin": "jī shǎo chéng duō",
//    "chengyujs": " 积累少量的东西，能成为巨大的数量。",
//    "from_": " 《战国策·秦策四》：“积薄而为厚，聚少而为多。”《汉书·董仲舒传》：“聚少成多，积小致巨。”",
//    "example": " 其实一个人做一把刀、一个勺子是有限得很，然而～，这笔账就难算了，何况更是历年如此呢。 《二十年目睹之怪现状》第二十九回",
//    "yufa": " 连动式；作谓语、宾语、分句；用于事物的逐渐聚积",
//    "ciyujs": "[many a little makes a mickle;from small increments comes abundance;little will grow to much;penny and penny laid up will be many] 积累少数而渐成多数",
//    "yinzhengjs": "谓只要不断积累，就会从少变多。语出《汉书·董仲舒传》：“众少成多，积小致鉅。” 唐 李商隐 《杂纂》：“积少成多。” 宋 苏轼 《论纲梢欠折利害状》：“押纲纲梢，既与客旅附载物货，官不点检，专栏无由乞取；然梢工自须赴务量纳税钱，以防告訐，积少成多，所获未必减於今日。” 清 薛福成 《陈派拨兵船保护华民片》：“惟海军船数不多，经费不裕，势难分拨，兵轮久驻海外， 华 民集貲，积少成多，未尝不愿供给船费。” 包天笑 《钏影楼回忆录·入泮》：“这项赏封，不过数十文而已，然积少成多，亦可以百计。”",
//    "tongyi": [
//    "集腋成裘",
//    "聚沙成塔",
//    "日积月累",
//    "积水成渊"
//    ],
//    "fanyi": [
//    "杯水车薪"
//    ]
//    },
}
