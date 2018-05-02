//
//  loginViewController.swift
//  digup_symptoms
//
//  Created by Akhil Yaragangu on 2/13/17.
//  Copyright © 2017 Akhil Yaragangu. All rights reserved.
//

import UIKit

var patient_login = 0
class loginViewController: UIViewController {

    @IBOutlet weak var login_text: UITextField!
    
    @IBOutlet weak var password_text: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "doctor-orange.png")
        self.view.insertSubview(backgroundImage, atIndex: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func login(sender: AnyObject) {
        
        let myUrl =  "http://localhost:8888/diguplogin.php";
        let url = NSURL(string:myUrl)
        let request = NSMutableURLRequest (URL: url!)
        print("======access==========")
        request.HTTPMethod = "POST"
        let postString = "loginid=" + login_text.text! + "&pass=" + password_text.text!;
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
                    if(resultvalue == "patient login successfull") {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            print("inised the segue")
                            patient_login = 1
                            let logindetails = NSUserDefaults.standardUserDefaults()
                            logindetails.setValue(self.login_text.text, forKey: "patient_id")
                            //logindetails.setValue(self.text_password.text, forKey: "password")
                            //logindetails.setValue(department!, forKey:  "department")
                            
                            self.performSegueWithIdentifier("loginaccess", sender: self);
                        }
                        
                    } else if(resultvalue == "doctor login successfull") {
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            print("inised the segue")
                            let logindetails = NSUserDefaults.standardUserDefaults()
                            logindetails.setValue(self.login_text.text, forKey: "doctor_id")
                            //logindetails.setValue(self.text_password.text, forKey: "password")
                            //logindetails.setValue(department!, forKey:  "department")
                            self.performSegueWithIdentifier("doctor_login", sender: self);
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func dispalyalertmessage (userMessage: String) {
        
        let myalert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        let okAction = UIAlertAction(title:"ok", style:UIAlertActionStyle.Default, handler:nil);
        myalert.addAction(okAction);
        self.presentViewController(myalert, animated:true, completion:nil);
        
        
    }


}
