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
    
    
    @IBOutlet weak var Picker: UIPickerView!
    @IBOutlet weak var betmax: UIButton!
    @IBOutlet weak var betone: UIButton!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        <#code#>
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        <#code#>
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

   
}
