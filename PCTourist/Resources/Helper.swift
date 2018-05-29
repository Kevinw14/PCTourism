//
//  Helper.swift
//  PCTourist
//
//  Created by Kevin Wood on 5/8/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit

//Blue
//let mainColor = UIColor(red: 14/255, green: 121/255, blue: 178/255, alpha: 1.0)
//Tart Orange
//let mainColor = UIColor(red: 254/255, green: 74/255, blue: 73/255, alpha: 1/0)
//Pastel Red
let mainColor = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1/0)

func dayOfWeek() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: Date())
}
