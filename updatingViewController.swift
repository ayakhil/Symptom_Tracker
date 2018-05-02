//
//  updatingViewController.swift
//  digup_symptoms
//
//  Created by Akhil Yaragangu on 2/15/17.
//  Copyright © 2017 Akhil Yaragangu. All rights reserved.
//

import UIKit

class updatingViewController: UIViewController {
    var time_start = 0
    var compare_string = ""
    var severity = ""
    var time_login = NSDate()
    var time_tracking = 0.00
    var segment = 0
    var login_id = ""
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var duration_label: UILabel!
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var segment_update: UISegmentedControl!
    @IBOutlet weak var display_time: UITextField!
    @IBOutlet weak var mild: UIButton!
    
    @IBAction func mild(sender: AnyObject) {
        severity = "Mild"
        print("time_start")
        print(time_start)
        if (time_start == 0) {
            timestarter()
        }
        }
    @IBAction func medium(sender: AnyObject) {
        severity = "Medium"
        print("time_start")
        print(time_start)
        if (time_start == 0) {
            timestarter()
        }
    }
    @IBAction func strong(sender: AnyObject) {
        severity = "Strong"
        print("time_start")
        print(time_start)
        if (time_start == 0) {
            timestarter()
        }
    }
    @IBAction func extreem(sender: AnyObject) {
        severity = "Extreem"
        print("time_start")
        print(time_start)
        if (time_start == 0) {
            timestarter()
        }
    }
    @IBOutlet weak var collection_severity: UICollectionView!
    @IBOutlet weak var duration_time: UITextField!
    @IBAction func datePickerAction(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.stringFromDate(datepicker.date)
        self.display.text = strDate
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let logindetail = NSUserDefaults.standardUserDefaults()
        login_id = logindetail.stringForKey("patient_id")!

//        display_time.delegate = self
//        display_time.keyboardType = .NumberPad
        switch (segment_update.selectedSegmentIndex) {
            
        case 0:
            print("segment0")

            datepicker.userInteractionEnabled = false
            self.duration_label.hidden = true
            duration_time.userInteractionEnabled = false
            self.duration_time.hidden = true
            let dateformatter = NSDateFormatter()
            dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle        // calendar = NSCalendar.currentCalendar()
            display.text = dateformatter.stringFromDate(NSDate())
            segment = 0
            compare_string = dateformatter.stringFromDate(NSDate())
            
        case 1:
            print("segment1")
            datepicker.userInteractionEnabled = true
            duration_time.userInteractionEnabled = true
            self.duration_label.hidden = false
            self.duration_time.hidden = false
            let dateformatter = NSDateFormatter()
            dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle        // calendar = NSCalendar.currentCalendar()
            display.text = dateformatter.stringFromDate(NSDate())
            compare_string = dateformatter.stringFromDate(NSDate())
            segment = 1
            
            
        default:
            datepicker.userInteractionEnabled = false
            duration_time.userInteractionEnabled = false
            self.duration_time.hidden = true
            self.duration_label.hidden = true
            let dateformatter = NSDateFormatter()
            dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle        // calendar = NSCalendar.currentCalendar()
            display.text = dateformatter.stringFromDate(NSDate())
            
            //compare_string = dateformatter.stringFromDate(NSDate())
        }

    }
    
    func timestarter() {
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle
        compare_string = dateformatter.stringFromDate(NSDate())
        time_start = 1
        print(compare_string)
    }
    

    @IBAction func save_button(sender: AnyObject) {
        var display_time_check = duration_time.text;
        print("============++")
        print(severity)
        print(duration_time.text)
        //if (display.text != compare_string) {
        if (severity == "") {
            dispalyalertmessage("severity is required");
            return;
        } else {
            if (segment == 1) {
                print("============++")
                let d_time = duration_time.text
                if(duration_time.text!.isEmpty) {
                    
                    dispalyalertmessage("duration time is required");
                    return;
                    
                } else {
                    print("before updating in database if time is update")
                    time_tracking = Double(d_time!)!
                    //updatedatabase()
                }
            } else {
                time_tracking = gettime(time_login)
                print(time_tracking)
                print("in else state where update is done in run time")
            }
            
        }
        //register(student_id!, pass : upassword.text!, f_name : firstname.text!, l_name : last_name.text!, dept: department.text!)
        updatedatabase(severity, time_tracking: time_tracking, time: NSDate() )
       

        //updatedatabase(severity: String, time_tracking: Double, time: NSDate)
                       //severity: String, time_tracking: Int, compare_string: NSDate )
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func gettime(time_opened: NSDate) -> NSTimeInterval {
        let current_date = NSDate()
        var check_time = 0.00
        print(time_opened)
        check_time = current_date.timeIntervalSinceDate(time_opened)
        //sleep(10)
        
               return(check_time)
        
    }

    func dispalyalertmessage (userMessage: String) {
        
        let myalert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        let okAction = UIAlertAction(title:"ok", style:UIAlertActionStyle.Default, handler:nil);
        myalert.addAction(okAction);
        self.presentViewController(myalert, animated:true, completion:nil);
        
    }
    
    
    @IBAction func segment_load(sender: AnyObject) {
        datepicker.reloadInputViews()
        self.datepicker.reloadInputViews()
        self.viewDidLoad()
    }
    //everity: String, time_tracking: Int, compare_string: NSDate
    //register(patient_id : String, pass : String, f_name : String, l_name : String, doctor : String, disease: String
    func updatedatabase(severity: String, time_tracking: Double, time: NSDate) {
//        print("timetracking====")
//        print(time_tracking);
//        print("=====")
//        print(severity);
//        print(compare_string);
    
    let myUrl =  "http://localhost:8888/symptomtracker_update.php";
    let url = NSURL(string:myUrl)
    let request = NSMutableURLRequest (URL: url!)
    print("======access==========")
    request.HTTPMethod = "POST"
        let get_time_tracker = String(time_tracking)
        let get_time = String(time)
        let postString = "login_id=" + login_id + "&severity=" + severity + "&get_time_tracker=" + get_time_tracker + "&get_time=" + get_time + "&patient_symptom_position=" + "";
        print(postString)
        print("==========")

    print(postString)
    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
    
    let task = NSURLSession.sharedSession().dataTaskWithRequest (request){
        data, response, error in
        if error != nil
        {
            print("error=\(error)")
            return
        }
        response
        
        let responseString =  NSString (data: data!, encoding: NSUTF8StringEncoding)
        print ("response String: \(responseString)");
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers
                ) as? NSDictionary
            
            if  let parseJSON = json {
                let resultvalue = parseJSON["Message"] as? String
                print ("result: \(resultvalue)")
                if(resultvalue == "login successfull") {
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        print("inised the segue")
                        self.performSegueWithIdentifier("loginaccess", sender: self);
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let myAlert = UIAlertController(title: "Alert", message:"wrong userid or password", preferredStyle: UIAlertControllerStyle.Alert);
                        let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.Default){
                            action in self.dismissViewControllerAnimated(true, completion: nil);
                        }
                        myAlert.addAction(okAction);
                        self.presentViewController(myAlert, animated: true, completion: nil)
                    })
                    
                }
            }
            
        } catch {
            print(error)
        }
        
        
    }
    task.resume()
    
    

    }

    
}
