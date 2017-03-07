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
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tipPercentLabel.selectedSegmentIndex = defaults.integer(forKey: "defaultVal")
        self.mainView.alpha = 1
        self.displayView.alpha = 0
        self.tipPercentLabel.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       tipPercentLabel.selectedSegmentIndex = defaults.integer(forKey: "defaultVal")
        self.mainView.alpha = 1
        self.displayView.alpha = 0
        self.tipPercentLabel.alpha = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.calcTip()
        billBoxLabel.becomeFirstResponder()
        self.mainView.alpha = 1
        self.displayView.alpha = 0
        self.tipPercentLabel.alpha = 0
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTap(_ sender: AnyObject) {
        //view.endEditing(true);
    }

    @IBAction func calcTip(_ sender: AnyObject? = nil) {
        let tipPercent = [0.18,0.2,0.25]
        let bill = Double(billBoxLabel.text!) ?? 0
        let tip = bill * tipPercent[tipPercentLabel.selectedSegmentIndex]
        let total = tip + bill
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
       
        UIView.animate(withDuration: 0.2, animations: {
            // This causes first view to fade in and second view to fade out
            self.displayView.alpha = 1
            self.tipPercentLabel.alpha = 1
            if(!self.flag){
            self.billBoxLabel.frame.origin.y = self.billBoxLabel.frame.origin.y - 100
            }
            self.flag = true
          //  self.mainView.alpha = 0
            })
    }
}

