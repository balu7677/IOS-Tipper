//
//  SettingsViewController.swift
//  Tipper
//
//  Created by Balaji Tummala on 3/5/17.
//  Copyright © 2017 Balaji Tummala. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var MainView: UIView!
    @IBOutlet weak var defaultTipPercent: UISegmentedControl!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultTipPercent.selectedSegmentIndex = defaults.integer(forKey: "defaultVal")
        defaults.set(27, forKey: "Visited")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.MainView.backgroundColor = UIColor(red: 255/255.0, green: 253/255.0, blue: 194/255.0, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTipChange(_ sender: AnyObject) {
        defaults.set(defaultTipPercent.selectedSegmentIndex, forKey: "defaultVal")
        defaults.synchronize()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
