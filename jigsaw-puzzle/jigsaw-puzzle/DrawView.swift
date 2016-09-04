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

    override func drawRect(rect: CGRect) {
        //print("drawRect \(rect)")
        
        if ctx == nil {
            ctx = UIGraphicsGetCurrentContext()
        }

        /* adjust coregraphics's coordinated system */
        CGContextTranslateCTM(ctx, 0.0, self.frame.size.height);
        CGContextScaleCTM(ctx, 1.0, -1.0);
        
        if cgImage == nil {
            let imagePath = NSBundle.mainBundle().pathForResource("sun", ofType: "bmp")
            uiimg = UIImage.init(named:imagePath!, inBundle:nil, compatibleWithTraitCollection:nil)
            /* TODO: set the uiimage as the user coordinated system */
            cgImage = uiimg!.CGImage;
        }

         if drawModel == nil {
            drawModel = DrawModel()
            drawModel?.SetDstPanel(CGRectMake(0.0, 0.0, 660, 660), _subImageBorderLeft: 5, _subImageBorderBottom: 5)
            subImageCount = drawModel!.ImportImage(imageSize: uiimg!.size, lineNum: 3, rowNum: 3)
            drawModel!.SetBlank(0)
        }
        
        /* draw panel according draw model */
        for index in 0 ... subImageCount-1 {
            let subImage = drawModel!.GetSubImage(index)
            let _image = CGImageCreateWithImageInRect(cgImage, subImage!.SrcRect)
            
            CGContextDrawImage(ctx, subImage!.DstRect, _image)
            if subImage!.Blank {
                CGContextMoveToPoint(ctx, subImage!.DstRect.origin.x, subImage!.DstRect.origin.y)
                CGContextAddLineToPoint(ctx, subImage!.DstRect.origin.x + subImage!.DstRect.size.width, subImage!.DstRect.origin.y + subImage!.DstRect.size.height)
                CGContextStrokePath(ctx)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        var p = (touches as NSSet).anyObject()?.locationInView(self)
        p!.y = self.frame.size.height - p!.y
        //print("touch begin.\(p!.x), \(p!.y)")
        //print("\(self.frame.size.height), \(self.frame.size.width)")
        if drawModel != nil {
            drawModel!.Click(p!)
        }
        //increase = (increase + 1) % 2
        self.setNeedsDisplay()
        //self.setNeedsDisplayInRect(CGRectMake(0, 0, p!.x, p!.y))
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //let p = (touches as NSSet).anyObject()?.locationInView(self)
        //p!.y = self.frame.size.height - p!.y
        //print("touch end.\(p!.x), \(p!.y)")
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //let p = (touches as NSSet).anyObject()?.locationInView(self)
        //p!.y = self.frame.size.height - p!.y
        //print("touch moved.\(p!.x), \(p!.y)")
    }
    
}
