//
//  CustomTextField.swift
//  PokeDex
//
//  Created by Jesper Bertelsen on 25/03/2021.
//

import Foundation
import UIKit

class CsmLabel: UILabel{
    var scale: CGFloat?
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustFontSize()
        scale = minFontSize()
        defaultFontSize(size:30)
        fontColor()
        
        
    }
    
    func adjustFontSize() {
        self.adjustsFontSizeToFitWidth = true
    }
    func minFontSize() -> CGFloat {
        let scale: CGFloat = 8.0/30.0
        self.minimumScaleFactor = scale
        return scale
    }
    func defaultFontSize(size: CGFloat) {
        self.font = UIFont(name: "Helvetica Neue", size: size)
        
    }
    
    func fontColor() {
        self.textColor = UIColor(red:250/255, green:214/255, blue:29/255, alpha: 1)
    }
        
}
