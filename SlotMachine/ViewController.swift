//
//  GameViewController.swift
//  SlotMachine
//
//  Created by Sreeram Ramakrishnan on 2019-01-24.
//  Copyright © 2019 Centennial College. All rights reserved.
// STUDENT NAME : SREERAM RAMAKRISHNAN & SHERLYN LOBO
// STUDENT ID : 301042442 & 301013071
// PROGRAM : ADVANCED IOS DEVELOPMENT

import UIKit
import SpriteKit
import GameplayKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let images = [#imageLiteral(resourceName: "dimond"),#imageLiteral(resourceName: "crown"),#imageLiteral(resourceName: "bar"),#imageLiteral(resourceName: "seven"),#imageLiteral(resourceName: "cherry"),#imageLiteral(resourceName: "lemon")]
    
    
    @IBOutlet weak var userlabel: UILabel!
    @IBOutlet weak var winning: UILabel!
    @IBOutlet weak var betamount: UILabel!
    @IBOutlet weak var credits: UILabel!
    @IBOutlet weak var spinhandle: UIImageView!
    @IBOutlet weak var Picker: UIPickerView!
    @IBOutlet weak var betstepper: UIStepper!
    
    var winval = 0
    var bet : Int = 1{
        didSet{//update ui
            betamount.text = "\(currentCredits)"
        }
    }
    
    @IBAction func stepperaction(_ sender: UIStepper) {
        betstepper.maximumValue = Double(currentCredits)
        let amount = Int(sender.value)
        if currentCredits >= amount{
            bet = amount
            betamount.text = "\(amount)"
        }
    }
    
    
    // get current displayed cash, remove '$'
    var currentCredits : Int{
        guard let credit = credits.text, !(credits.text?.isEmpty)! else {
            return 0
        }
        return Int(credit.replacingOccurrences(of: "$", with: ""))!
    }
    
    func startGame(){
        if Model.instance.isFirstTime(){ // check if it's first time playing
            Model.instance.updateScore(label: credits, credit: 500)
        }else{ // get last saved score
            credits.text = "\(Model.instance.getScore())"
        } // set max bet
        betstepper.maximumValue = Double(currentCredits)
    }
    
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
    @IBAction func quitapp(_ sender: UIButton) {
        exit(0)
    }
    
    @IBAction func reset(_ sender: UIButton) {
        winning.text = "0"
        bet = 1
        betamount.text = "1"
        credits.text = "500"
    }
    
   
    @IBAction func maxact(_ sender: UIButton) {
        bet = 1
        betamount.text = "1"
        
    }
    
    @IBAction func realmaxact(_ sender: UIButton) {
        betamount.text = "\(currentCredits)"
        bet = currentCredits
    }
    
    
    @IBAction func spinBarAct(_ sender: UITapGestureRecognizer) {
        spinAction()
    }
    
    func checkWin(){
        
        var lastRow = -1
        var counter = 0
        
        for i in 0..<Picker.numberOfComponents{
            let row : Int = Picker.selectedRow(inComponent: i) % images.count 
            if lastRow == row{
                counter += 1
            } else {
                lastRow = row
                counter = 1
            }
        }
        
        if counter == 3{ // winning
            Model.instance.play(sound: Constant.win_sound)
           
            betstepper.maximumValue = Double(currentCredits)
            
            userlabel.text = "YOU WON"
            winval += 200 + bet * 2
            winning.text = "\(winval)"
            Model.instance.updateScore(label: credits,credit: (currentCredits + 200) + (bet * 2))
        } else { // losing
            userlabel.text = "TRY AGAIN"
            Model.instance.updateScore(label: credits,credit: (currentCredits - bet))
        }
        
        // if cash is over
        if currentCredits <= 0 {
            gameOver()
        }else{  // update bet stepper
            if Int(betstepper.value) > currentCredits {
                betstepper.maximumValue = Double(currentCredits)
                bet = currentCredits
                betstepper.value = Double(currentCredits)
            }
        }
    }
    
    
    func spinAction(){
        spinhandle.isUserInteractionEnabled = false // disable clicking
        // animation of bandit handle 
        animate(view: spinhandle, images: #imageLiteral(resourceName: "mot").spriteSheet(cols: 14, rows: 1), duration: 0.5, repeatCount: 1)
        Model.instance.play(sound: Constant.spin_sound)
        roll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.checkWin()
            self.spinhandle.isUserInteractionEnabled = true
        }
        
    }
    
    func roll(){ // roll pickerview
        var delay : TimeInterval = 0
        // iterate over each component, set random img
        for i in 0..<Picker.numberOfComponents{
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                self.randomSelectRow(in: i)
            })
            delay += 0.30
        }
    }
    
    func randomSelectRow(in comp : Int){
        let r = Int(arc4random_uniform(UInt32(8 * images.count))) + images.count
        Picker.selectRow(r, inComponent: comp, animated: true)
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down: self.spinAction()
            default:break
            }
        }
    }
    
    func gameOver(){ // when game is over, show alert
        let alert = UIAlertController(title: "Game Over", message: "You have \(currentCredits) \nPlay Again?", preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.startGame()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
       
    }

   
}
