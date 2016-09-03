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
    var uiimg : UIImage? = nil
    var cgImage : CGImage? = nil
    var increase : Int = 0
    var drawModel : DrawModel? = nil
    var subImageCount : Int = 0

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func drawRect(rect: CGRect) {
        print("drawRect \(rect)")
        
        if ctx == nil {
            ctx = UIGraphicsGetCurrentContext()
        }
        /*CGContextMoveToPoint(ctx, 0, 0)
        CGContextAddLineToPoint(ctx, 150, 200)
        CGContextStrokePath(ctx)*/
        
        if cgImage == nil {
            let imagePath = NSBundle.mainBundle().pathForResource("test99", ofType: "bmp")
            uiimg = UIImage.init(named:imagePath!, inBundle:nil, compatibleWithTraitCollection:nil)
            cgImage = uiimg!.CGImage;
        }

         if drawModel == nil {
            drawModel = DrawModel()
            drawModel?.SetDstPanel(CGRectMake(0.0, 0.0, 660, 660), _subImageBlankH: 10, _subImageBlankV: 10)
            subImageCount = drawModel!.ImportImage(imageSize: uiimg!.size, hNum: 3, vNum: 3)
        }
        
        /* draw panel according draw model */
        for index in 0 ... subImageCount-1 {
            let subImage = drawModel!.GetSubImage(index)
            let _image = CGImageCreateWithImageInRect(cgImage, subImage!.SrcRect)
            CGContextDrawImage(ctx, subImage!.DstRect, _image)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let p = (touches as NSSet).anyObject()?.locationInView(self)
        print("touch begin.\(p!.x), \(p!.y)")
    
        //increase = (increase + 1) % 2
        //self.setNeedsDisplay()
        self.setNeedsDisplayInRect(CGRectMake(0, 0, p!.x, p!.y))
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //let p = (touches as NSSet).anyObject()?.locationInView(self)
        //print("touch end.\(p!.x), \(p!.y)")
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //let p = (touches as NSSet).anyObject()?.locationInView(self)
        //print("touch moved.\(p!.x), \(p!.y)")
    }
    
}
