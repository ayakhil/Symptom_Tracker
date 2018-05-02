//
//  doctor_display_tablevieTableViewController.swift
//  digup_symptoms
//
//  Created by Akhil Yaragangu on 3/27/17.
//  Copyright © 2017 Akhil Yaragangu. All rights reserved.
//

import UIKit
  var getdata: [[String: AnyObject]] = []
class doctor_display_tablevieTableViewController: UITableViewController,UISearchResultsUpdating, UISearchControllerDelegate {
    
    let identifier                  = "get_data"
    var results                     : NSMutableArray?
    var searchController            : UISearchController?
    var searchResultsController     : UITableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSearchBarController()
        
       self.getpatientlist()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.hideSearchBar()
       
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
        if tableView == self.searchResultsController?.tableView {
            if let results = self.results {
                return results.count
            } else {
                return 0
            }
        } else {
            return getdata.count
        }

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.identifier, forIndexPath: indexPath)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
            headerView.backgroundColor = UIColor.clearColor()
        
         cell.selectionStyle =  UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textAlignment = NSTextAlignment.Left
        cell.textLabel?.textColor = UIColor.redColor()
        //cell.textLabel?.font = UIFont.systemFontOfSize(19.0)
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(19.0)
        cell.backgroundColor = UIColor.lightGrayColor()
       

        // Configure the cell...
        var text: String?
        if tableView == self.searchResultsController?.tableView {
            cell.textLabel?.textColor = UIColor.redColor()
            if let results = self.results {
                text = results.objectAtIndex(indexPath.row)["patient_firstname"] as? String
            }
        } else {

            text = getdata[indexPath.row]["patient_firstname"] as? String

        //cell.textLabel?.text = getdata[indexPath.row]["patient_firstname"] as! String
//        let last_name = getdata[indexPath.row]["patient_lastname"] as! String
//        
//         = "\(last_name)" + " " + "\(first_name)"
       // cell.detailTextLabel?.text = getdata[indexPath.row]["patient_login_id"] as? String
      
        }
        
        cell.textLabel?.text = text
        
        return cell
        

    }
    
    func addSearchBarController() {
        //search bar
        let resultsTableView = UITableView(frame: self.tableView.frame)
        self.searchResultsController = UITableViewController()
        self.searchResultsController?.tableView = resultsTableView
        self.searchResultsController?.tableView.dataSource = self
        self.searchResultsController?.tableView.delegate = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.identifier)
        self.searchResultsController?.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.identifier)
        self.searchController = UISearchController(searchResultsController: self.searchResultsController!)
        self.searchController?.searchResultsUpdater = self
        self.searchController?.delegate = self
        self.searchController?.searchBar.sizeToFit() // bar size
        self.tableView.tableHeaderView = self.searchController?.searchBar
        self.definesPresentationContext = true
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var selectectDetails: [String: AnyObject] = [:]
        
        if tableView == self.searchResultsController?.tableView {
            //self.searchController?.active = false
            //self.hideSearchBar()
            selectectDetails = self.results![indexPath.row] as! [String : AnyObject]
        } else {
            selectectDetails = getdata[indexPath.row]
        }
        
        self.navigateToDetailsVC(selectectDetails)
    }
    
    func navigateToDetailsVC(withDetails: [String: AnyObject]) {
        let detailsVC = self.storyboard?.instantiateViewControllerWithIdentifier("selectionViewController") as! selectionViewController
        detailsVC.selected = withDetails
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if self.searchController?.searchBar.text!.lengthOfBytesUsingEncoding(NSUTF32StringEncoding) > 0 {
            
            if let results = self.results {
                results.removeAllObjects()
            } else {
                results = NSMutableArray(capacity: getdata.count)
            }
            
            let searchBarText = self.searchController!.searchBar.text
            
            let predicate = NSPredicate(block: { (get_data: AnyObject, b: [String : AnyObject]?) -> Bool in
                var range: NSRange = 0 as NSRange
                let value = get_data["patient_firstname"] as! NSString
                range = value.rangeOfString(searchBarText!, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            })
            
            // Get results from predicate and add them to the appropriate array.
            let filteredArray = (getdata as NSArray).filteredArrayUsingPredicate(predicate)
            self.results?.addObjectsFromArray(filteredArray)
            
            // Reload a table with results.
            self.searchResultsController?.tableView.reloadData()
        }
    }
    func didDismissSearchController(searchController: UISearchController) {
        UIView.animateKeyframesWithDuration(0.5, delay: 0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            self.hideSearchBar()
            }, completion: nil)
    }
    
    func hideSearchBar() {
        let yOffset = self.navigationController!.navigationBar.bounds.height + UIApplication.sharedApplication().statusBarFrame.height
        self.tableView.contentOffset = CGPointMake(0, self.searchController!.searchBar.bounds.height - yOffset)
    }

    func getpatientlist() {
        let logindetails = NSUserDefaults.standardUserDefaults()
        let doctor_login = logindetails.stringForKey("doctor_id")
        print("doctor_login=======")
        print(doctor_login)
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/doctor_patient_list.php")!)
        request.HTTPMethod = "POST"
        
        let postString = "doctor_login=" + doctor_login!
        print("postString in doctor dispaly view view")
        print(postString)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
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
                            getdata = data
                            print("==========")
                            print(getdata)
                            print("getdata")
                           //getdata.sortInPlace{ ($0["patient_lastname"] as? String) < ($1["patient_firstname"] as? String )}
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
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
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

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // if (readanddepart.selectedSegmentIndex == 0) {
        
        if (segue.identifier == "list_patient") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //getdata[indexPath.row]["type"] = "read"
                    let selecteddata = getdata[indexPath.row]
                    print(selecteddata)
                    
                    //url_read
                    let dvc = segue.destinationViewController as! selectionViewController
                    dvc.selected = selecteddata
                        //dvc.delegate = self
        }
    }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation


}
