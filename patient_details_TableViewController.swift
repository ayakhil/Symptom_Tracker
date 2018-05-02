//
//  patient_details_TableViewController.swift
//  digup_symptoms
//
//  Created by Akhil Yaragangu on 3/27/17.
//  Copyright © 2017 Akhil Yaragangu. All rights reserved.
//

import UIKit
var get_patient_list: [[String: AnyObject]] = []
class patient_details_TableViewController: UITableViewController {
    var selectedpatient: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()

    @IBOutlet var check: UITableView!
    @IBOutlet weak var multiselect: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        check.allowsMultipleSelection = true
        if(patient_login == 1) {
            let logindetail = NSUserDefaults.standardUserDefaults()
            let patient_login_id = logindetail.stringForKey("patient_id")!
        }
        self.title = (selectedpatient["patient_login_id"] as? String)
        let patient_login_id = selectedpatient["patient_login_id"] as? String
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/doctor_display_list.php")!)
        request.HTTPMethod = "POST"
        if((patient_login_id) != nil){
        let postString = "patient_login_id=" + patient_login_id!
            print(postString)
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
        }
        else {
            let logindetail = NSUserDefaults.standardUserDefaults()
            let patient_login_id = logindetail.stringForKey("patient_id")!
            let postString = "patient_login_id=" + patient_login_id
            print(postString)
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
        }
        print("postString in doctor dispaly view view")
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest (request){
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            let responseString =  NSString (data: data!, encoding: NSUTF8StringEncoding)
            //
            
            print ("response String: \(responseString)");
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                //let jsonData:NSArray = try (NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSArray)!
                
                if  let parseJSON = json {
                    
                    let resultvalue = parseJSON["message"] as? String
                    
                    if(resultvalue == "successful") {
                        if let data = parseJSON["details"] as? [[String: AnyObject]] {
                            get_patient_list = data
                            print("==========")
                            print(get_patient_list)
                            print("getdata")
                            
                        }
                        self.tableView.reloadData()
                    }
                    //  let answers = roster_cardSet["answers"]as? String
                    
                }
                
            } catch {
                print(error)
            }
        }
        //executing the task
        task.resume()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return get_patient_list.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("details", forIndexPath: indexPath)
        let first_name = get_patient_list[indexPath.row]["patient_firstname"] as! String
        let last_name = get_patient_list[indexPath.row]["patient_lastname"] as! String
        let patient_symptom_severity = get_patient_list[indexPath.row]["patient_symptom_severity"]!
        let patient_symptom_duration = get_patient_list[indexPath.row]["patient_symptom_duration"]!
        let patient_symptoms_date_time = get_patient_list[indexPath.row]["patient_symptoms_date_time"]!
        
        

        cell.textLabel?.text = "\(last_name)" + " " + "\(first_name)"
        cell.detailTextLabel?.text = "severity:" + ("\(patient_symptom_severity)") + " " + "duration:" + "\(patient_symptom_duration)" + " " + "date_on:" + "\(patient_symptoms_date_time)"
             // Configure the cell...
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.accessoryType = .Checkmark
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.accessoryType = .None
        }
    }

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "segueA" {
//            if let destination = segue.destinationViewController as? selectionViewController {
//                if let selectedRows = check.indexPathsForSelectedRows {
//                    let dvc = segue.destinationViewController as! patient_details_TableViewController
//                    dvc.selectedpatient = selectedRows.st
//                    //hear you have option to send items that are selected to another controller or send only indexPath.
//                }
//            }
//            
//        }
//    }

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        // if (readanddepart.selectedSegmentIndex == 0) {
//        
//        if (segue.identifier == "list_patient_detail") {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
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
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
