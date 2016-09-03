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
    var ctx : CGContext? = nil
    var cgImage : CGImage? = nil

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func drawRect(rect: CGRect) {
        if ctx == nil {
            ctx = UIGraphicsGetCurrentContext()
        }
        CGContextMoveToPoint(ctx, 0, 0)
        CGContextAddLineToPoint(ctx, 150, 200)
        CGContextStrokePath(ctx)
        
        if cgImage == nil {
            let imagePath = NSBundle.mainBundle().pathForResource("test99", ofType: "bmp")
            let uiimg = UIImage.init(named:imagePath!, inBundle:nil, compatibleWithTraitCollection:nil)
            cgImage = uiimg!.CGImage;
        }
        //var rect = CGRectMake(0, 0, 600, 600)
        //CGContextDrawImage(ctx, rect, cgImage)
        
        var srcRect = CGRectMake(0, 0, 200, 200)
        var dstRect = CGRectMake(20, 20, 200, 200)
        for x in [0.0, 200.0, 400.0] {
            dstRect.origin.y = 20
            for y in [0.0, 200.0, 400.0] {
                srcRect.origin.x = CGFloat(x)
                srcRect.origin.y = CGFloat(y)
                let subImage = CGImageCreateWithImageInRect(cgImage, srcRect) //TODO: release subImage
                CGContextDrawImage(ctx, dstRect, subImage)
                dstRect.origin.y = dstRect.origin.y + dstRect.size.height + 20
            }
            dstRect.origin.x = dstRect.origin.x + dstRect.size.width + 20
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let p = (touches as NSSet).anyObject()?.locationInView(self)
        print("touch begin.\(p!.x), \(p!.y)")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let p = (touches as NSSet).anyObject()?.locationInView(self)
        print("touch end.\(p!.x), \(p!.y)")
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let p = (touches as NSSet).anyObject()?.locationInView(self)
        print("touch moved.\(p!.x), \(p!.y)")
    }
    
}
