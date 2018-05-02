//
//  initalViewController.swift
//  digup_symptoms
//
//  Created by Akhil Yaragangu on 2/5/17.
//  Copyright © 2017 Akhil Yaragangu. All rights reserved.
//

import UIKit

class initalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    @IBAction func patient(sender: AnyObject) {
    //        self.performSegueWithIdentifier("patient", sender: self)
    //    }
    //
    //    @IBAction func doctor(sender: AnyObject) {
    //        self.performSegueWithIdentifier("doctor", sender: self)
    //    }
    //    @IBAction func login(sender: AnyObject) {
    //        self.performSegueWithIdentifier("login", sender: self)
    //    }

    
    @IBAction func patient(sender: AnyObject) {
        self.performSegueWithIdentifier("patient", sender: self)
    }
    @IBAction func login(sender: AnyObject) {
        self.performSegueWithIdentifier("login", sender: self)
    }

    @IBAction func doctor(sender: AnyObject) {
        self.performSegueWithIdentifier("doctor", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
