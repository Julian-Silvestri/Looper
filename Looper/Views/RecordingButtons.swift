//
//  RecordingButtons.swift
//  Looper
//
//  Created by Julian Silvestri on 2021-12-14.
//

import UIKit

class RecordingButtons: UIButton {
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.backgroundColor = #colorLiteral(red: 0, green: 0.5858765244, blue: 1, alpha: 1)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
