//
//  OvalView.swift
//  MiracleMessages
//
//  Created by Winfred Raguini on 7/9/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

class OvalView: UIView {

    override func draw(_ rect: CGRect)
    {
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 240, height: 320))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = ovalPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 5.0
        
        self.layer.addSublayer(shapeLayer)
    }
}
