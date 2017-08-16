//
//  TipViewController.swift
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
    var currentTipSegments = [Double]()
    // TODO: make these global/shared between controllers 
    let TIP_SEGMENTS_KEY = "tip_percent_segments"
    let DEFAULT_TIP_INDEX_KEY = "default_tip_index"
    let LAST_BILL_AMOUNT_KEY = "last_bill_amount"
    let LAST_BILL_TIMESTAMP_KEY = "last_bill_timestamp"

    override func viewDidLoad() {
        super.viewDidLoad()
        billField.becomeFirstResponder()
        initSegments()
        initTipSelection()
        initBillAmount()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initSegments()
        initTipSelection()
        calculateTip(nil)
    }
    
    func initBillAmount () {
        // pull timestamp and last value out of defaults
        let lastBillAmount = defaults.object(forKey: LAST_BILL_AMOUNT_KEY) as? Double
        let lastBillTimestamp = defaults.object(forKey: LAST_BILL_TIMESTAMP_KEY) as? Date
        
        // check if values exist
        if (lastBillTimestamp != nil && lastBillAmount != nil) {
            let difference = Calendar.current.dateComponents([.minute], from: lastBillTimestamp!, to: Date())
        
            // use the value if it was created in the last 10 mintes; 
            // otherwise, delete the old key data
            if (difference.minute! < 10) {
                billField.text = String(lastBillAmount!)
            } else {
                defaults.removeObject(forKey: LAST_BILL_AMOUNT_KEY)
            }
        }
    }
    
    func initSegments () {
        let userSegments = defaults.array(forKey: TIP_SEGMENTS_KEY) as? [Int] ?? [Int]()
        let tipColletion = userSegments.isEmpty ? defaultSegments : userSegments
        
        for(index, tip) in tipColletion.enumerated() {
            // set both segment text and the global [double] tip collection to use for calculation
            tipSegmentedControl.setTitle(String(tip) + "%", forSegmentAt: index)
            currentTipSegments.append(Double(tip) / Double(100))
        }
    }
    
    func initTipSelection () {
        let selectedTipIndex = defaults.object(forKey: DEFAULT_TIP_INDEX_KEY) as? Int ?? 0
        tipSegmentedControl.selectedSegmentIndex = selectedTipIndex
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any?) {
        // calculate bill
        let bill = Double(billField.text!) ?? 0
        let tip = bill * currentTipSegments[tipSegmentedControl.selectedSegmentIndex]
        let total = bill + tip
        
        // display bill value
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
        // save bill amount to defaults
        defaults.set(bill, forKey: LAST_BILL_AMOUNT_KEY)
        defaults.set(Date(), forKey: LAST_BILL_TIMESTAMP_KEY)
    }
    
}

