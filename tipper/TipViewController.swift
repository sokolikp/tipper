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
    @IBOutlet weak var tipDescriptionLabel: UILabel!
    @IBOutlet weak var totalDescriptionLabel: UILabel!
    
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
                billField.text = lastBillAmount! != Double(0) ? String(format: "%.0f",lastBillAmount!) : ""
            } else {
                defaults.removeObject(forKey: LAST_BILL_AMOUNT_KEY)
            }
        }
    }
    
    func initSegments () {
        let userSegments = defaults.array(forKey: TIP_SEGMENTS_KEY) as? [Int]
        let tipColletion = userSegments!.isEmpty ? defaultSegments : userSegments!
        currentTipSegments = []
        
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
    
    @IBAction func onTypeTextField(_ sender: Any) {
        let currentPosition = billField.center.y
        
        // animate down
        if (billField.text == "" && currentPosition < 250) {
            UIView.animate(withDuration: 0.5) {
                self.billField.center.y += 150
                self.tipLabel.center.y += 200
                self.totalLabel.center.y += 200
                self.tipSegmentedControl.center.y += 200
                self.tipDescriptionLabel.center.y += 200
                self.totalDescriptionLabel.center.y += 200
            }
        } else if (billField.text != "" && currentPosition > 250) { // animate up
            UIView.animate(withDuration: 0.5) {
                self.billField.center.y -= 150
                self.tipLabel.center.y -= 200
                self.totalLabel.center.y -= 200
                self.tipSegmentedControl.center.y -= 200
                self.tipDescriptionLabel.center.y -= 200
                self.totalDescriptionLabel.center.y -= 200
            }
        }
    }
    
    @IBAction func calculateTip(_ sender: Any?) {
        // calculate bill
        let bill = Double(billField.text!) ?? 0
        let tip = bill * currentTipSegments[tipSegmentedControl.selectedSegmentIndex]
        let total = bill + tip
        
        // display bill value
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.locale = NSLocale.current
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.maximumFractionDigits = 2;
        tipLabel.text = formatter.string(from: NSNumber(value: tip))
        totalLabel.text = formatter.string(from: NSNumber(value: total))
        
        // save bill amount to defaults
        defaults.set(Double(bill), forKey: LAST_BILL_AMOUNT_KEY)
        defaults.set(Date(), forKey: LAST_BILL_TIMESTAMP_KEY)
        defaults.synchronize()
    }
    
}

