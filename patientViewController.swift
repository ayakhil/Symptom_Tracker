//
//  patientViewController.swift
//  digup_symptoms
//
//  Created by Akhil Yaragangu on 2/6/17.
//  Copyright © 2017 Akhil Yaragangu. All rights reserved.
//

import UIKit
var docter_list     : [[String: AnyObject]] = []
class patientViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    var editInProgress:UITextField?
    
    @IBAction func cancel(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var create: UIButton!
    @IBOutlet weak var firstname_text: UITextField!
    
    @IBOutlet weak var lastname_text: UITextField!
    
    @IBOutlet weak var doctorname_text: UITextField!
    
    @IBOutlet weak var patientid_text: UITextField!
    
    @IBOutlet weak var password_text: UITextField!
    
    @IBOutlet weak var password_re_text: UITextField!
    
    @IBOutlet weak var symp_text: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doctorname_text.keyboardType = .Default
        _ = doctor()
        //let dept = deptlist
        //var delegate = deptlist
        
        let dept_picker = UIPickerView()
        //[self.viewDidLoad()]
        doctorname_text.inputView = dept_picker
        dept_picker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func create(sender: AnyObject) {
        let patient_firstname = firstname_text.text;
        let patient_lastname = lastname_text.text;
        let patient_id = patientid_text.text;
        let doctor_name = doctorname_text.text;
        let password = password_text.text;
        let disease_sympt = symp_text.text
        let password_re = password_re_text.text
        
        
        if(patient_firstname!.isEmpty || patient_lastname!.isEmpty || patient_id!.isEmpty || password!.isEmpty || password_re!.isEmpty || disease_sympt!.isEmpty)
        {
            dispalyalertmessage("all fields required");
            return;
        }
        if (password?.characters.count <= 6) {
            dispalyalertmessage("Enter password atleast with 6 characters");
            return;
        }
        // check the same password for both fields
        if (password != password_re) {
            dispalyalertmessage("password doesn't match");
            return;
        }
        let variable_login = isValidEmail(patientid_text.text!)
        print("variable_login")
        print(variable_login)
        if (variable_login == false)
        {
            dispalyalertmessage("enter valid login id");
            return;
        }
        
        register(patient_id!, pass : password_text.text!, f_name : firstname_text.text!, l_name : lastname_text.text!, doctor: doctorname_text.text!, disease: symp_text.text!)
        

    }
     var doctor_picker = UIPickerView()
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    func dispalyalertmessage (userMessage: String) {
        
        let myalert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        let okAction = UIAlertAction(title:"ok", style:UIAlertActionStyle.Default, handler:nil);
        myalert.addAction(okAction);
        self.presentViewController(myalert, animated:true, completion:nil);
        
    }
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return docter_list.count
        
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return docter_list[row]["doctor_login_id"] as? String
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        doctorname_text.text = docter_list[row]["doctor_login_id"] as? String
        
        create.enabled = true
        
    }
    func dismissKeyboard()  {
        editInProgress?.resignFirstResponder()
    }

    
    
    
    func register(patient_id : String, pass : String, f_name : String, l_name : String, doctor : String, disease: String) {
        let myUrl =  "http://localhost:8888/register_digup.php";
        let url = NSURL(string:myUrl)
        let request = NSMutableURLRequest (URL: url!)
        print("======register==========")
        request.HTTPMethod = "POST"
        let postString = "patient_id=" + patient_id + "&pass=" + pass + "&f_name=" + f_name + "&l_name=" + l_name + "&doctor=" + doctor + "&disease=" + disease;
        print("=========");
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
                    if(resultvalue == "user registered successfully") {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        print("inside the data aftter loging")
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            if (resultvalue == "user already in use"){
                                
                                let myAlert = UIAlertController(title: "Alert", message:"user alreday_exists", preferredStyle: UIAlertControllerStyle.Alert);
                                let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.Default){
                                    action in self.dismissViewControllerAnimated(true, completion: nil);
                                }
                                
                                myAlert.addAction(okAction);
                                
                                self.presentViewController(myAlert, animated: true, completion: nil)
                                
                                
                            } else {
                                print("checking================")
                                
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
    func doctor() {
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/symptom_doctor_list.php")!)
        request.HTTPMethod = "POST"
        
        let postString = "doctorlist"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest (request){ data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseString =  NSString (data: data!, encoding: NSUTF8StringEncoding)
            print ("response String: \(responseString)");
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                if  let parseJSON = json {
                    let resultvalue = parseJSON["message"] as? String
                    if(resultvalue == "successful") {
                        if let department = parseJSON["dept"] as? [[String: AnyObject]] {
                             docter_list = department
                        }
                    }
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        [self.viewDidLoad()]
                    } )
                }
                
            } catch {
                print(error)
            }
        }
        
        task.resume()

    }
}
