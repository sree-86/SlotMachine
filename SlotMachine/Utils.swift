//
//  Utils.swift
//  SlotMachine
//
//  Created by Sreeram Ramakrishnan on 2019-01-24.
//  Copyright © 2019 Centennial College. All rights reserved.
// STUDENT NAME : SREERAM RAMAKRISHNAN & SHERLYN LOBO
// STUDENT ID : 301042442 & 301013071
// PROGRAM : ADVANCED IOS DEVELOPMENT
import UIKit

struct Constant {
    static let user_credit : String = "credit"
    static let win_sound : String = "win"
    static let spin_sound : String = "spin"
    static let is_save_exist : String = "save_exist"
    
}

extension UIViewController{
    func animate(view : UIImageView, images : [UIImage] , duration : TimeInterval , repeatCount : Int){
        view.animationImages = images
        view.animationDuration = duration
        view.animationRepeatCount = repeatCount
        view.startAnimating()
    }
}

extension UIImage{
    
    func spriteSheet(cols : UInt, rows : UInt) -> [UIImage]{
        
        let w = self.size.width / CGFloat(cols)
        let h = self.size.height / CGFloat(rows)
        
        var rect = CGRect(x: 0, y: 0, width: w, height: h)
        var arr : [UIImage] = []
        
        for _ in 0..<rows{
            for _ in 0..<cols{
                
                //crop
                let subImage = self.crop(rect)
                //add to array
                arr.append(subImage)
                
                //go to next image in row
                rect.origin.x += w
            }
            
            //go to next row
            rect.origin.x = 0
            rect.origin.y += h
        }
        
        //done, return the array
        return arr
        
    }
    
    
    func crop(_ rect : CGRect) -> UIImage{
        guard let imageRef = self.cgImage?.cropping(to: rect) else {
            return UIImage()
        }
        return UIImage(cgImage: imageRef)
    }
    
}

