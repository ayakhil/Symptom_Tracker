//
//  selectionViewController.swift
//  digup_symptoms
//
//  Created by Akhil Yaragangu on 4/4/17.
//  Copyright © 2017 Akhil Yaragangu. All rights reserved.
//

import UIKit
var selected_button = ""
class selectionViewController: UIViewController {
    var selected: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
    
    @IBAction func last30days(sender: AnyObject) {
        selected_button = "last30days"
    }

    @IBAction func Mild(sender: AnyObject) {
        selected_button = "mild"
    }
    @IBAction func medium(sender: AnyObject) {
        selected_button = "medium"
    }
    @IBAction func hard(sender: AnyObject) {
        selected_button = "hard"
    }
    @IBOutlet weak var Extreem: UIButton!
    
    @IBAction func extreeme(sender: AnyObject) {
        selected_button = "extreeme"
    }
    @IBAction func lessthan1min(sender: AnyObject) {
        selected_button = "lessthan1min"
    }
    @IBAction func lessthan5mins(sender: AnyObject) {
        selected_button = "lessthan5mins"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    
    @IBAction func ok(sender: AnyObject) {
      //  prepareForSegue(UIStoryboardSegue, sender: AnyObject?)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "details_after_selection" {
            if let destination = segue.destinationViewController as? patient_details_TableViewController {
                destination.selectedpatient = self.selected
            }
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        // if (readanddepart.selectedSegmentIndex == 0) {
//        
//        
//        if (segue.identifier == "list_patient_detail") {
//           
//                //getdata[indexPath.row]["type"] = "read"
//                let selecteddata = getdata[indexPath.row]
//                print(selecteddata)
//                
//                //url_read
//                let dvc = segue.destinationViewController as! patient_details_TableViewController
//                dvc.selectedpatient = selecteddata
//                //dvc.delegate = self
//            }
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
