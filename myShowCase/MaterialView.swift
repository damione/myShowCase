//
//  MaterialView.swift
//  myShowCase
//
//  Created by Damion Hanson on 2016-04-11.
//  Copyright © 2016 Damion Hanson. All rights reserved.
//

import UIKit
//@IBDesignable - Used when using .xib files

class MaterialView: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
        
    }
}
