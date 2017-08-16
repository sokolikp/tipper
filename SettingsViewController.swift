//
//  SettingsViewController.swift
//  tipper
//
//  Created by Paul Sokolik on 8/14/17.
//  Copyright © 2017 Paul Sokolik. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var percentage1Input: UITextField!
    @IBOutlet weak var percentage2Input: UITextField!
    @IBOutlet weak var percentage3Input: UITextField!
    @IBOutlet weak var tipSegmentedControl: UISegmentedControl!
    
    let defaultSegments: [Int] = [18, 20, 25]
    let defaults = UserDefaults.standard
    // TODO: make these global/shared between controllers
    let TIP_SEGMENTS_KEY = "tip_percent_segments"
    let DEFAULT_TIP_INDEX_KEY = "default_tip_index"
    var tipTextFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTextFields()
        setSegmentsText(false)
        initSelectedSegment()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initTextFields () {
        let userSegments = defaults.array(forKey: TIP_SEGMENTS_KEY) as? [Int] ?? [Int]()
        let tipCollection = userSegments.isEmpty ? defaultSegments : userSegments
        
        percentage1Input.text = String(tipCollection[0])
        percentage2Input.text = String(tipCollection[1])
        percentage3Input.text = String(tipCollection[2])
        
        tipTextFields = [percentage1Input, percentage2Input, percentage3Input]
    }
    
    func setSegmentsText (_ saveToDefaults: Bool) {
        var newSegments = [Int]() // only used if we are saving to defaults
        
        for(index, textField) in tipTextFields.enumerated() {
            let stringNum = textField.text!.isEmpty ? "0" : textField.text!
            
            newSegments.append(Int(stringNum)!)
            tipSegmentedControl.setTitle(stringNum + "%", forSegmentAt: index)
        }
        
        if (saveToDefaults) {
            defaults.set(newSegments, forKey: TIP_SEGMENTS_KEY)
        }
    }
    
    func initSelectedSegment () {
        let selectedTipIndex = defaults.object(forKey: DEFAULT_TIP_INDEX_KEY) as? Int ?? 0
        tipSegmentedControl.selectedSegmentIndex = selectedTipIndex
    }
    
    @IBAction func onSegmentChanged(_ sender: Any) {
        defaults.set(tipSegmentedControl.selectedSegmentIndex, forKey: DEFAULT_TIP_INDEX_KEY)
    }
    
    @IBAction func updatePercentageSegments(_ sender: Any) {
        setSegmentsText(true)
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }

}
