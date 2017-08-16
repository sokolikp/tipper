//
//  ViewController.swift
//  tipper
//
//  Created by Paul Sokolik on 8/13/17.
//  Copyright © 2017 Paul Sokolik. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipSegmentedControl: UISegmentedControl!
    
    let defaultSegments: [Int] = [18, 20, 25]
    let defaults = UserDefaults.standard
    // TODO: make these global/shared between controllers 
    let TIP_SEGMENTS_KEY = "tip_percent_segments"
    let DEFAULT_TIP_INDEX_KEY = "default_tip_index"

    override func viewDidLoad() {
        super.viewDidLoad()
        initSegmentsText()
        initTipSelection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initSegmentsText()
        initTipSelection()
    }
    
    func initSegmentsText () {
        let userSegments = defaults.array(forKey: TIP_SEGMENTS_KEY) as? [Int] ?? [Int]()
        let tipCollection = userSegments.isEmpty ? defaultSegments : userSegments
        
        for(index, tip) in tipCollection.enumerated() {
            tipSegmentedControl.setTitle(String(tip) + "%", forSegmentAt: index)
        }
    }
    
    func initTipSelection () {
        let selectedTipIndex = defaults.object(forKey: DEFAULT_TIP_INDEX_KEY) as? Int ?? 0
        tipSegmentedControl.selectedSegmentIndex = selectedTipIndex
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        let tipSelection = [0.18, 0.2, 0.25]
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipSelection[tipSegmentedControl.selectedSegmentIndex]
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
    
}

