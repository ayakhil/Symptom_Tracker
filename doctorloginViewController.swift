//
//  doctorloginViewController.swift
//  digup_symptoms
//
//  Created by Akhil Yaragangu on 2/8/17.
//  Copyright © 2017 Akhil Yaragangu. All rights reserved.
//

import UIKit

class doctorloginViewController: UIViewController {

   
    @IBOutlet weak var first_name: UITextField!
    
    @IBOutlet weak var last_name: UITextField!
    
    @IBOutlet weak var doctor_login: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var password_re: UITextField!
    
    @IBOutlet weak var specialization: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
              self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func Create(sender: AnyObject) {
        let doctor_first_name = first_name.text;
        let doctor_last_name = last_name.text;
        let doctor_id = doctor_login.text;
        let password_d = password.text;
        let password_de_re = password_re.text;
        let specialization_do = specialization.text;
        
        if(doctor_first_name!.isEmpty || doctor_last_name!.isEmpty || doctor_id!.isEmpty || password_d!.isEmpty || password_de_re!.isEmpty || specialization_do!.isEmpty)
        {
            dispalyalertmessage("all fields required");
            return;
        }
        if (password_d?.characters.count <= 6) {
            dispalyalertmessage("Enter password atleast with 6 characters");
            return;
        }
        
        if (password_d != password_de_re) {
            dispalyalertmessage("password doesn't match");
            return;
        }
        let variable_login = isValidEmail(doctor_login.text!)
        print("variable_login")
        print(variable_login)
        if (variable_login == false)
        {
            dispalyalertmessage("enter valid login id");
            return;
        }
        
        register(doctor_id!, pass : password.text!, f_name : first_name.text!, l_name : last_name.text!, specialization: specialization.text!)
        

    }
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func dispalyalertmessage (userMessage: String) {
        
        let myalert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        let okAction = UIAlertAction(title:"ok", style:UIAlertActionStyle.Default, handler:nil);
        myalert.addAction(okAction);
        self.presentViewController(myalert, animated:true, completion:nil);
        
    }

    func register(doctor_login : String, pass : String, f_name : String, l_name : String, specialization : String) {
        let myUrl =  "http://localhost:8888/doctorregister.php";
        let url = NSURL(string:myUrl)
        let request = NSMutableURLRequest (URL: url!)
        print("======register==========")
        request.HTTPMethod = "POST"
      let postString = "doctor_login=" + doctor_login + "&pass=" + pass + "&f_name=" + f_name + "&l_name=" + l_name + "&specialization=" + specialization;
        
       // let postString = "student_id=" + doctor_login + "&pass=" + pass + "&f_name=" + f_name + "&l_name=" + l_name + "&dept=" + specialization;
        
        print("=========");
        print (postString)
        print("")
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest (request){
            data, response, error in
            
            print("inside task")
            if error != nil
            {
                print("error=\(error)")
                return
            }
            print("response = \(response)")
            print("\n")
            response
            
            let responseString =  NSString (data: data!, encoding: NSUTF8StringEncoding)
            print ("response String: \(responseString)");
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers
                    ) as? NSDictionary
                
                if  let parseJSON = json {
                    let resultvalue = parseJSON["Message"] as? String
                    print ("resultvalue:\(resultvalue)")
                    
                    //var isUserlogin:Bool = false;
                    if(resultvalue == "registration successfull") {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            if (resultvalue == "Doctor exits"){
                                
                                let myAlert = UIAlertController(title: "Alert", message:"Doctor exits", preferredStyle: UIAlertControllerStyle.Alert);
                                let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.Default){
                                    action in self.dismissViewControllerAnimated(true, completion: nil);
                                }
                                
                                myAlert.addAction(okAction);
                                
                                self.presentViewController(myAlert, animated: true, completion: nil)
                                
                                
                            } else {
                                
                                let myAlert = UIAlertController(title: "Alert", message:"some problem in database", preferredStyle: UIAlertControllerStyle.Alert);
                                let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.Default){
                                    action in self.dismissViewControllerAnimated(true, completion: nil);
                                }
                                
                                myAlert.addAction(okAction);
                                
                                self.presentViewController(myAlert, animated: true, completion: nil)
                            }
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

}
