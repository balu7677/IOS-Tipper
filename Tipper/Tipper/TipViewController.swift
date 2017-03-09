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
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var displayView: UIView!
    
    let defaults = UserDefaults.standard
    var numberFormatter = NumberFormatter()
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
                billBoxLabel.text = String(Int((defaults.double(forKey: "Bill"))))
                if(!(self.billBoxLabel.text?.isEmpty)!){
                    self.moveLabelUp()
                }
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
        tipPercentLabel.selectedSegmentIndex = defaults.integer(forKey: "defaultVal")
        billBoxLabel.placeholder = Locale.current.currencySymbol
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       tipPercentLabel.selectedSegmentIndex = defaults.integer(forKey: "defaultVal")
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
            okAction.isEnabled = false
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }

        let tipPercent = [0.18,0.2,0.25,0.0]
        let bill = Double(billBoxLabel.text!) ?? 0
        defaults.set(bill, forKey: "Bill")
        defaults.set(Date(), forKey: "Date")
        let tip = bill * ((self.customTip>0 && self.tipPercentLabel.selectedSegmentIndex == 3) ? (self.customTip) : (tipPercent[tipPercentLabel.selectedSegmentIndex]))
        let total = tip + bill
        tipLabel.text = (self.tipPercentLabel.selectedSegmentIndex != 3) ? (self.retNumberFormatter().string(from: NSNumber(value: tip))!) : "$0.00"
        totalLabel.text = (self.tipPercentLabel.selectedSegmentIndex != 3) ? (self.retNumberFormatter().string(from: NSNumber(value: total))!) : "$0.00"
        
        UIView.animate(withDuration: 0.2, animations: {
            // This causes first view to fade in and second view to fade out
            if(!(self.billBoxLabel.text?.isEmpty)!){
                    self.moveLabelUp()
                } else {
                    self.moveLabelDown()
                }
            })
        firstVisit = true
        
    }
    
    func alertTextFieldDidChange(sender : UITextField){
        let alertV = self.presentedViewController as? UIAlertController
        let customTip = (alertV!.textFields?.first)! as UITextField
        let okAction = alertV!.actions.last! as UIAlertAction
        okAction.isEnabled = (customTip.text?.characters.count)! > 0
        self.customTip = (okAction.isEnabled) ? (0.01 * Double(customTip.text!)!) : 0.0
        let bill = Double(billBoxLabel.text!) ?? 0
        let tip = bill * (self.customTip)
        let total = tip + bill
        tipLabel.text = self.retNumberFormatter().string(from: NSNumber(value: tip))!
        totalLabel.text = self.retNumberFormatter().string(from: NSNumber(value: total))!
        
    }
    
    func retNumberFormatter() -> NumberFormatter {
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 3
        numberFormatter.locale = Locale.current
        return numberFormatter
    }
    
    func moveLabelDown(){
        if(self.movedUp && self.firstVisit){
            self.billBoxLabel.frame.origin.y = self.billBoxLabel.frame.origin.y + 100
            self.displayView.alpha = 0
            self.tipPercentLabel.alpha = 0
            self.movedUp = false
            self.movedDown = true
        }
    }
    
    func moveLabelUp(){
        if(self.movedDown){
            self.billBoxLabel.frame.origin.y = self.billBoxLabel.frame.origin.y - 100
            self.displayView.alpha = 1
            self.tipPercentLabel.alpha = 1
            self.movedDown = false
            self.movedUp = true
        }
    }
    
}

