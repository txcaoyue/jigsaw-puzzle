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
    private var orgPosition = SubImagePosition(0, 0)
    private var randId = arc4random()
    
    var RandID : UInt32 {
        get {
            return randId
        }
        
        set(v) {
            randId = v
        }
    }
    
    var Blank : Bool {
        get {
            return blank
        }
        
        set(v) {
            blank = v
        }
    }
    
    var OrgPosition : SubImagePosition {
        get {
            return orgPosition
        }
        set(v) {
            orgPosition = v
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
    
    func Done(curPosition : SubImagePosition) -> Bool {
        return ((curPosition.line == orgPosition.line) && (curPosition.row == orgPosition.row))
    }
    
    internal func toString() -> String {
        return "src:\(srcRect) dst:\(dstRect)"
    }
}

struct SubImagePosition {
    init(_ _line : Int, _ _row : Int){
        line = _line
        row = _row
    }
    
    var line : Int = 0
    var row : Int = 0
}

class DrawModel {
    /* about draw panel of UIView */
    private var dstRect = CGRectMake(0.0, 0.0, 100.0, 100.0)
    private var dstBlockSize = CGSizeMake(300.0, 300.0)
    private var dstRectInBlock = CGRectMake(50.0, 50.0, 200.0, 200.0)
    private var subImageBorderBottom : CGFloat = 0.0
    private var subImageBorderLeft : CGFloat = 0.0
    
    /* about image */
    private var srcSize = CGSizeMake(100.0, 100.0)
    private var lineNum : Int = 3;
    private var rowNum : Int = 3;
    private var subImages = [[SubImage]]()
    private var blankLine : Int = 0
    private var blankRow : Int = 0
    
    private func DstRectByPosition(line : Int, _ row : Int) -> CGRect{
        var rect : CGRect = CGRect()
        rect.origin.x = dstRect.origin.x + CGFloat(row) * dstBlockSize.width + dstRectInBlock.origin.x
        rect.origin.y = dstRect.origin.y + CGFloat(line) * dstBlockSize.height + dstRectInBlock.origin.y
        rect.size = dstRectInBlock.size
        return rect
    }
    
    private func SubImageCanMove(position : SubImagePosition) -> SubImagePosition? {
        /* the black subImage, can't move. */
        if position.line == blankLine && position.row == blankRow {
            return nil
        }
        
        /* near by the blank subimage */
        if (position.line == blankLine && abs(position.row-blankRow) == 1) {
            return SubImagePosition(blankLine, blankRow)
        }
        
        if (position.row == blankRow && abs(position.line-blankLine) == 1) {
            return SubImagePosition(blankLine, blankRow)
        }
        
        return nil
    }
    
    private func SwitchSubImage(pos1 : SubImagePosition, _ pos2 : SubImagePosition) -> Void {
        //print("before switch. pos1:\(subImages[pos1.line][pos1.row].toString())")
        let image = subImages[pos1.line][pos1.row]
        subImages[pos1.line][pos1.row] = subImages[pos2.line][pos2.row]
        subImages[pos2.line][pos2.row] = image
        
        /* update subImage dst rect in uiview*/
        subImages[pos1.line][pos1.row].DstRect = DstRectByPosition(pos1.line, pos1.row)
        subImages[pos2.line][pos2.row].DstRect = DstRectByPosition(pos2.line, pos2.row)
        
        /* update blank block position */
        if subImages[pos1.line][pos1.row].Blank {
            blankLine = pos1.line
            blankRow = pos1.row
        }
        
        if subImages[pos2.line][pos2.row].Blank {
            blankLine = pos2.line
            blankRow = pos2.row
        }
        
        //print("after switch. pos1:\(subImages[pos1.line][pos1.row].toString())")
    }
    
    private func DisOrderSubImages() -> Void {
        /* dis-order */
        var tempSubImages = [SubImage]()
        for i in 0...lineNum*rowNum-1 {
            subImages[i/rowNum][i%rowNum].RandID = arc4random()
            tempSubImages.append(subImages[i/rowNum][i%rowNum])
        }
        tempSubImages.sortInPlace({$0.RandID > $1.RandID})
        for i in 0...lineNum*rowNum-1 {
            subImages[i/rowNum][i%rowNum] = tempSubImages[i]
            subImages[i/rowNum][i%rowNum].DstRect = DstRectByPosition(i/rowNum, i%rowNum)
        }
    }
    
    internal func SetDstPanel(_dstRect : CGRect, _subImageBorderLeft :CGFloat, _subImageBorderBottom : CGFloat)
    {
        dstRect = _dstRect
        subImageBorderBottom = _subImageBorderBottom
        subImageBorderLeft = _subImageBorderLeft
    }
    
    internal func ImportImage(imageSize size : CGSize, lineNum _line : Int, rowNum _row : Int) -> Int {
        srcSize.height = size.height
        srcSize.width = size.width
        lineNum = _line
        rowNum = _row
        let subw : CGFloat = size.width / CGFloat(rowNum)
        let subh : CGFloat = size.height / CGFloat(lineNum)
        
        dstBlockSize = CGSize(width: (dstRect.size.width / CGFloat(rowNum)), height: (dstRect.size.height / CGFloat(lineNum)))
        if (2 * subImageBorderLeft >= dstBlockSize.width || 2 * subImageBorderBottom >= dstBlockSize.height) {
            dstRectInBlock = CGRectMake(dstBlockSize.width / 2, dstBlockSize.height / 2, 1, 1)
        } else {
            dstRectInBlock = CGRectMake(subImageBorderLeft, subImageBorderBottom, dstBlockSize.width - 2 * subImageBorderLeft, dstBlockSize.height - 2 * subImageBorderBottom)
        }
        
        if (subImages.count != 0) {
            print("Already Import Image.")
            return 0
        }
        subImages = [[SubImage]]()
        for line in 0...lineNum-1 {
            subImages.append([SubImage]())
            for row in 0...rowNum-1 {
                let subImage = SubImage()
                //subImage.Blank = false /* default */
                subImage.orgPosition = SubImagePosition(line, row)
                //subImage.SrcRect = CGRect(x: CGFloat(row) * subw, y: CGFloat(line) * subh, width: subw, height: subh) /* TODO : as the uiimage is not the user coordinated system */
                subImage.SrcRect = CGRect(x: CGFloat(row) * subw, y: CGFloat(lineNum - 1 - line) * subh, width: subw, height: subh)
                subImage.DstRect = DstRectByPosition(line, row)
                subImages[line].append(subImage)
                //print("subImages[\(line)][\(row)]:\(subImages[line][row].toString())")
            }
        }
        
        DisOrderSubImages()
        
        return lineNum * rowNum
    }
    
    internal func SetBlank(index : Int) -> Void {
        if subImages.count == 0 {
            return
        }
        
        if index >= lineNum * rowNum {
            return
        }
        
        blankLine = index/rowNum
        blankRow = index%rowNum
        subImages[blankLine][blankRow].Blank = true
    }
    
    internal func GetSubImage(index : Int) -> SubImage? {
        if subImages.count == 0 {
            return nil
        }
        
        if index >= lineNum * rowNum {
            return nil
        }
        
        return subImages[index/rowNum][index%rowNum]
    }
    
    internal func Click(point : CGPoint) -> Void {
        if (!dstRect.contains(point)) {
            print("click out of panel.")
            return
        }
        
        let line : Int = Int((point.y - dstRect.origin.y) / dstBlockSize.height)
        let row : Int = Int((point.x - dstRect.origin.x) / dstBlockSize.width)
        
        let dstPosition = SubImageCanMove(SubImagePosition(line, row))
        if (dstPosition == nil) {
            //print("subImages[\(line)][\(row)] can't move.")
        } else {
            //print("subImages[\(line)][\(row)] can move to subImages[\(dstPosition!.line)][\(dstPosition!.row)].")
            SwitchSubImage(SubImagePosition(line, row), dstPosition!)
        }
    }
    
}