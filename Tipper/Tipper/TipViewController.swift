//
//  ViewController.swift
//  Tipper
//
//  Created by Balaji Tummala on 3/5/17.
//  Copyright © 2017 Balaji Tummala. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipPercentLabel: UISegmentedControl!
    @IBOutlet weak var billBoxLabel: UITextField!
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var displayView: UIView!
    
    let numberFormatter = NumberFormatter()
    var movedUp = true
    var movedDown = true
    var firstVisit = false
    var customTip = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(defaults.object(forKey: "Date") as? Date != nil){
            let timeElapsed = Date().timeIntervalSince(defaults.object(forKey: "Date") as! Date)
            //print("Time elapsed:\(timeElapsed)")
            if(timeElapsed < 600.00 && (defaults.double(forKey: "Bill")) > 0.0){
                billBoxLabel.text = String((defaults.double(forKey: "Bill")))
            }
        }
        //if(timeElapsed < 600){
            
        //}
        // Do any additional setup after loading the view, typically from a nib.
        tipPercentLabel.selectedSegmentIndex = defaults.integer(forKey: "defaultVal")
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       tipPercentLabel.selectedSegmentIndex = defaults.integer(forKey: "defaultVal")
       // self.mainView.alpha = 1
        //self.displayView.alpha = 1
        //self.tipPercentLabel.alpha = 1
        if(defaults.integer(forKey: "Visited") == 0 || (self.billBoxLabel.text?.isEmpty)!){
            self.displayView.alpha = 0
            self.tipPercentLabel.alpha = 0
        } else {
            if(defaults.integer(forKey: "Visited") == 27){
                self.displayView.alpha = 1
                self.tipPercentLabel.alpha = 1
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.calcTip()
        billBoxLabel.becomeFirstResponder()
     //   self.mainView.alpha = 1
        if(defaults.integer(forKey: "Visited") == 0 || (self.billBoxLabel.text?.isEmpty)!){
            self.displayView.alpha = 0
            self.tipPercentLabel.alpha = 0
        } else {
            if(defaults.integer(forKey: "Visited") == 27){
                self.displayView.alpha = 1
                self.tipPercentLabel.alpha = 1
            }
        }
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTap(_ sender: AnyObject) {
        //view.endEditing(true);
    }

    @IBAction func calcTip(_ sender: AnyObject? = nil) {
        
        if(self.tipPercentLabel.selectedSegmentIndex == 3){
            
            let alertController = UIAlertController(title: "Custom tip", message: "Please Enter tip %", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addTextField { (textField : UITextField) -> Void in
                textField.keyboardType = .decimalPad
                textField.placeholder = "$"
                textField.addTarget(self, action: #selector(self.alertTextFieldDidChange), for: UIControlEvents.editingChanged)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            }
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }

        let tipPercent = [0.18,0.2,0.25,0.0]
        let bill = Double(billBoxLabel.text!) ?? 0
        defaults.set(bill, forKey: "Bill")
        defaults.set(Date(), forKey: "Date")
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        numberFormatter.maximumFractionDigits = 3
        //numberFormatter.roundingMode = .down
        let tip = bill * ((self.customTip>0 && self.tipPercentLabel.selectedSegmentIndex == 3) ? (self.customTip) : (tipPercent[tipPercentLabel.selectedSegmentIndex]))
        let total = tip + bill
        tipLabel.text = (self.tipPercentLabel.selectedSegmentIndex != 3) ? (numberFormatter.string(from: NSNumber(value: tip))!) : "$0.00"
        totalLabel.text = (self.tipPercentLabel.selectedSegmentIndex != 3) ? (numberFormatter.string(from: NSNumber(value: total))!) : "$0.00"
      //  tipLabel.text = (self.tipPercentLabel.selectedSegmentIndex != 3) ? String(format: "$%.2f", tip) : "$0.00"
      //  totalLabel.text = (self.tipPercentLabel.selectedSegmentIndex != 3) ? String(format: "$%.2f", total) : "$0.00"
       
        UIView.animate(withDuration: 0.2, animations: {
            // This causes first view to fade in and second view to fade out
            if(!(self.billBoxLabel.text?.isEmpty)!){
                if(self.movedDown){
                    self.billBoxLabel.frame.origin.y = self.billBoxLabel.frame.origin.y - 100
                    self.displayView.alpha = 1
                    self.tipPercentLabel.alpha = 1
                    self.movedDown = false
                    self.movedUp = true}
                } else {
                    if(self.movedUp && self.firstVisit){
                        self.billBoxLabel.frame.origin.y = self.billBoxLabel.frame.origin.y + 100
                        self.displayView.alpha = 0
                        self.tipPercentLabel.alpha = 0
                        self.movedUp = false
                        self.movedDown = true
                    }
                }
            
            })
        firstVisit = true
        
    }
    
    func alertTextFieldDidChange(sender : UITextField){
        
        let alertV = self.presentedViewController as? UIAlertController
        let login = (alertV!.textFields?.first)! as UITextField
        let okAction = alertV!.actions.last! as UIAlertAction
        okAction.isEnabled = (login.text?.characters.count)! > 1
        self.customTip = 0.01 * Double(login.text!)!
        let bill = Double(billBoxLabel.text!) ?? 0
        let tip = bill * (self.customTip)
        let total = tip + bill
        numberFormatter.numberStyle = .currency
        //numberFormatter.roundingMode = .down
        numberFormatter.maximumFractionDigits = 3
        numberFormatter.locale = Locale.current
        tipLabel.text = numberFormatter.string(from: NSNumber(value: tip))!
        totalLabel.text = numberFormatter.string(from: NSNumber(value: total))!
        
    }
    
}

