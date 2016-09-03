//
//  DrawModel.swift
//  jigsaw-puzzle
//
//  Created by cy on 16/8/31.
//  Copyright © 2016年 cy. All rights reserved.
//

import Foundation
import ImageIO
import UIKit

class SubImage {
    private var blank = false
    private var srcRect = CGRectMake(0, 0, 200, 200)
    private var dstRect = CGRectMake(0, 0, 200, 200)
    private var orgIndexI0 : Int = 0
    private var orgIndexI1 : Int = 0
    
    var Blank : Bool {
        get {
            return blank
        }
        
        set(v) {
            blank = v
        }
    }
    
    var OrgIndex : (i0 : Int, i1 : Int) {
        get {
            return (orgIndexI0, orgIndexI1)
        }
        set(v) {
            orgIndexI0 = v.i0
            orgIndexI1 = v.i1
        }
    }
    
    var SrcRect : CGRect {
        get {
            return srcRect
        }
        
        set(v) {
            srcRect = v /* copy struct value */
        }
    }
    
    var DstRect : CGRect {
        get {
            return dstRect
        }
        
        set(v) {
            dstRect = v /* copy struct value */
        }
    }
    
    func Done(i0 : Int, _ i1 : Int) -> Bool {
        return orgIndexI0 == i0 && orgIndexI1 == i1
    }
    
    internal func toString() -> String {
        return "src:\(srcRect) dst:\(dstRect)"
    }
}

class DrawModel {
    /* about draw panel of UIView */
    var dstRect = CGRectMake(0.0, 0.0, 100.0, 100.0)
    var dstBlockSize = CGSizeMake(300.0, 300.0)
    var dstRectInBlock = CGRectMake(50.0, 50.0, 200.0, 200.0)
    var subImageBlankH : CGFloat = 0.0
    var subImageBlankV : CGFloat = 0.0
    
    /* about image */
    var srcSize = CGSizeMake(100.0, 100.0)
    var hNum : Int = 3;
    var vNum : Int = 3;
    
    internal func SetDstPanel(_dstRect : CGRect, _subImageBlankH : CGFloat, _subImageBlankV :CGFloat)
    {
        dstRect = _dstRect
        subImageBlankH = _subImageBlankH
        subImageBlankV = _subImageBlankV
    }
    
    internal func ImportImage(imageSize size : CGSize, hNum h : Int, vNum v : Int) -> Int {
        srcSize.height = size.height
        srcSize.width = size.width
        hNum = h
        vNum = v
        let subw : CGFloat = size.width / CGFloat(vNum)
        let subh : CGFloat = size.height / CGFloat(hNum)
        
        dstBlockSize = CGSize(width: (dstRect.size.width / CGFloat(vNum)), height: (dstRect.size.height / CGFloat(hNum)))
        if (2 * subImageBlankH >= dstBlockSize.width || 2 * subImageBlankV >= dstBlockSize.height) {
            dstRectInBlock = CGRectMake(dstBlockSize.width/2, dstBlockSize.height/2, 1, 1)
        } else {
            dstRectInBlock = CGRectMake(subImageBlankH, subImageBlankV, dstBlockSize.width-2*subImageBlankH, dstBlockSize.height-2*subImageBlankV)
        }
        
        if (subImages.count != 0) {
            print("Already Import Image.")
            return 0
        }
        subImages = [[SubImage]]()
        for line in 0...h-1 {
            subImages.append([SubImage]())
            
            for row in 0...v-1 {
                let subImage = SubImage()
                subImage.Blank = false
                subImage.OrgIndex = (line, row)
                subImage.SrcRect = CGRect(x: CGFloat(row) * subh, y: CGFloat(line) * subw, width: subw, height: subh)
                subImage.DstRect = DstRectByIndex(line, row)
                subImages[line].append(subImage)
                //print("subImages[\(line)][\(row)]:\(subImages[line][row].toString())")
            }
        }
        return h * v
    }
    
    internal func GetSubImage(index : Int) -> SubImage? {
        if subImages.count == 0 {
            return nil
        }
        
        if index >= hNum * vNum {
            return nil
        }
        
        return subImages[index/hNum][index%vNum]
    }
    
    private func DstRectByIndex(i0 : Int, _ i1 : Int) -> CGRect{
        var rect : CGRect = CGRect()
        rect.origin.x = dstRect.origin.x + CGFloat(i1) * dstBlockSize.width + dstRectInBlock.origin.x
        rect.origin.y = dstRect.origin.y + CGFloat(i0) * dstBlockSize.height + dstRectInBlock.origin.y
        rect.size = dstRectInBlock.size
        return rect
    }
    
    /* internal control */
    var subImages = [[SubImage]]()
    
}