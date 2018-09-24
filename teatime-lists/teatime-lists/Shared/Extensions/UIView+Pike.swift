//
//  UIView+Pike.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/24/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

public extension UIView {
    
    public enum PeakSide: Int {
        case Top
        case Left
        case Right
        case Bottom
    }
    
    public func addPikeOnView( side: PeakSide, size: CGFloat = 10.0) {
        self.layoutIfNeeded()
        let peakLayer = CAShapeLayer()
        var path: CGPath?
        switch side {
        case .Top:
            path = self.makePeakPathWithRect(rect: self.bounds, topSize: size, rightSize: 0.0, bottomSize: 0.0, leftSize: 0.0)
        case .Left:
            path = self.makePeakPathWithRect(rect: self.bounds, topSize: 0.0, rightSize: 0.0, bottomSize: 0.0, leftSize: size)
        case .Right:
            path = self.makePeakPathWithRect(rect: self.bounds, topSize: 0.0, rightSize: size, bottomSize: 0.0, leftSize: 0.0)
        case .Bottom:
            path = self.makePeakPathWithRect(rect: self.bounds, topSize: 0.0, rightSize: 0.0, bottomSize: size, leftSize: 0.0)
        }
        peakLayer.path = path
        let color = (self.backgroundColor?.cgColor)
        peakLayer.fillColor = color
        peakLayer.strokeColor = color
        peakLayer.lineWidth = 1
        peakLayer.position = CGPoint.zero
        self.layer.insertSublayer(peakLayer, at: 0)
    }
    
    
    func makePeakPathWithRect(rect: CGRect, topSize ts: CGFloat, rightSize rs: CGFloat, bottomSize bs: CGFloat, leftSize ls: CGFloat) -> CGPath {
        //                      P3
        //                    /    \
        //      P1 -------- P2     P4 -------- P5
        //      |                               |
        //      |                               |
        //      P16                            P6
        //     /                                 \
        //  P15                                   P7
        //     \                                 /
        //      P14                            P8
        //      |                               |
        //      |                               |
        //      P13 ------ P12    P10 -------- P9
        //                    \   /
        //                     P11
        
        let centerX = rect.width / 2
        let centerY = rect.height / 2
        var h: CGFloat = 0
        let path = CGMutablePath()
        var points: [CGPoint] = []
        // P1
        points.append(CGPoint(x:rect.origin.x,y: rect.origin.y))
        // Points for top side
        if ts > 0 {
            h = ts * sqrt(3.0) / 2
            let x = rect.origin.x + centerX
            let y = rect.origin.y
            points.append(CGPoint(x:x - ts,y: y))
            points.append(CGPoint(x:x,y: y - h))
            points.append(CGPoint(x:x + ts,y: y))
        }
        
        // P5
        points.append(CGPoint(x:rect.origin.x + rect.width,y: rect.origin.y))
        // Points for right side
        if rs > 0 {
            h = rs * sqrt(3.0) / 2
            let x = rect.origin.x + rect.width
            let y = rect.origin.y + centerY
            points.append(CGPoint(x:x,y: y - rs))
            points.append(CGPoint(x:x + h,y: y))
            points.append(CGPoint(x:x,y: y + rs))
        }
        
        // P9
        points.append(CGPoint(x:rect.origin.x + rect.width,y: rect.origin.y + rect.height))
        // Point for bottom side
        if bs > 0 {
            h = bs * sqrt(3.0) / 2
            let x = rect.origin.x + centerX
            let y = rect.origin.y + rect.height
            points.append(CGPoint(x:x + bs,y: y))
            points.append(CGPoint(x:x,y: y + h))
            points.append(CGPoint(x:x - bs,y: y))
        }
        
        // P13
        points.append(CGPoint(x:rect.origin.x, y: rect.origin.y + rect.height))
        // Point for left sidey:
        if ls > 0 {
            h = ls * sqrt(3.0) / 2
            let x = rect.origin.x
            let y = rect.origin.y + centerY
            points.append(CGPoint(x:x,y: y + ls))
            points.append(CGPoint(x:x - h,y: y))
            points.append(CGPoint(x:x,y: y - ls))
        }
        
        let startPoint = points.removeFirst()
        self.startPath(path: path, onPoint: startPoint)
        for point in points {
            self.addPoint(point: point, toPath: path)
        }
        self.addPoint(point: startPoint, toPath: path)
        return path
    }
    
    private func startPath( path: CGMutablePath, onPoint point: CGPoint) {
        path.move(to: CGPoint(x: point.x, y: point.y))
    }
    
    private func addPoint(point: CGPoint, toPath path: CGMutablePath) {
        path.addLine(to: CGPoint(x: point.x, y: point.y))
    }
}
