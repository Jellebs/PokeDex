//
//  BeskrivelsesLabel.swift
//  PokeDex
//
//  Created by Jesper Bertelsen on 25/03/2021.
//

import Foundation
import UIKit

class BskLabel: CsmLabel {
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        alignCenter(textAlignment: .left)
        fontColor()
        
    }
    
    func alignCenter(textAlignment: NSTextAlignment) {
        self.textAlignment = textAlignment
    }
    override func fontColor() {
        self.textColor = .darkGray
    }
}

extension UILabel {

    var actualFontSize: CGFloat {
    //initial label
     let fullSizeLabel = UILabel()
     fullSizeLabel.font = self.font
     fullSizeLabel.text = self.text
     fullSizeLabel.sizeToFit()

     var actualFontSize: CGFloat = self.font.pointSize * (self.bounds.size.width / fullSizeLabel.bounds.size.width);

    //correct, if new font size bigger than initial
      actualFontSize = actualFontSize < self.font.pointSize ? actualFontSize : self.font.pointSize;

     return actualFontSize
    }
}
