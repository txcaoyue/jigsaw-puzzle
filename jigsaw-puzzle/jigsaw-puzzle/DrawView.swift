//
//  DrawView.swift
//  jigsaw-puzzle
//
//  Created by cy on 16/8/28.
//  Copyright © 2016年 cy. All rights reserved.
//

import UIKit
import ImageIO

class DrawView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        CGContextMoveToPoint(ctx, 0, 0)
        CGContextAddLineToPoint(ctx, 150, 200)
        CGContextStrokePath(ctx)
        
        let imagePath = NSBundle.mainBundle().pathForResource("test99", ofType: "bmp")
        var uiimg = UIImage.init(named:imagePath!, inBundle:nil, compatibleWithTraitCollection:nil)
        var cgImage = uiimg!.CGImage;
        //var rect = CGRectMake(0, 0, 600, 600)
        //CGContextDrawImage(ctx, rect, cgImage)
        
        var srcRect = CGRectMake(0, 0, 200, 200)
        var dstRect = CGRectMake(0, 0, 200, 200)
        for x in [0.0, 200.0, 400.0] {
            for y in [0.0, 200.0, 400.0] {
                srcRect.origin.x = CGFloat(x)
                srcRect.origin.y = CGFloat(y)
                dstRect.origin.x = CGFloat(x)
                dstRect.origin.y = CGFloat(y)
                var subImage = CGImageCreateWithImageInRect(cgImage, srcRect)
                CGContextDrawImage(ctx, dstRect, subImage)
            }
        }
    }
}
