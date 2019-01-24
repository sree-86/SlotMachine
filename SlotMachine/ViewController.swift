//
//  GameViewController.swift
//  SlotMachine
//
//  Created by Sreeram Ramakrishnan on 2019-01-24.
//  Copyright © 2019 Centennial College. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let images = [#imageLiteral(resourceName: "dimond"),#imageLiteral(resourceName: "crown"),#imageLiteral(resourceName: "bar"),#imageLiteral(resourceName: "seven"),#imageLiteral(resourceName: "cherry"),#imageLiteral(resourceName: "lemon")]
    
    
    @IBOutlet weak var spinhandle: UIImageView!
    @IBOutlet weak var Picker: UIPickerView!
    @IBOutlet weak var betmax: UIButton!
    @IBOutlet weak var betone: UIButton!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return images.count * 10
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let index = row % images.count
        return UIImageView(image: images[index])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return images[component].size.height + 1
    }
    
    @IBAction func spinAction(_ sender: UIButton) {
        spinAction()
    }
    
    func spinAction(){
        spinhandle.isUserInteractionEnabled = false // disable clicking
        // animation of bandit handle
        animate(view: spinhandle, images: #imageLiteral(resourceName: "mot").spriteSheet(cols: 14, rows: 1), duration: 0.5, repeatCount: 1)
        userIndicatorlabel.text = ""
        Model.instance.play(sound: Constant.spin_sound)
        roll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.checkWin()
            self.spinhandle.isUserInteractionEnabled = true
        }
        
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.down: self.spinAction()
            default:break
            }
        }
    }
    
    func animate(view : UIImageView, images : [UIImage] , duration : TimeInterval , repeatCount : Int){
        view.animationImages = images
        view.animationDuration = duration
        view.animationRepeatCount = repeatCount
        view.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

   
}
