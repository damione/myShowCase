//
//  MaterialTextField.swift
//  myShowCase
//
//  Created by Damion Hanson on 2016-04-11.
//  Copyright © 2016 Damion Hanson. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {
    
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).CGColor
        layer.borderWidth = 1.0
        //layer.backgroundColor = UIColor(red: BG_COLOR, green: BG_COLOR, blue: BG_COLOR, alpha: 1).CGColor

    }
    
    //For placeholder
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }

    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
}
