//
//  GoogleTableViewController.swift
//  vmwatch
//
//  Created by Yuxuan Zhang on 2017-01-08.
//  Copyright © 2017 ECE496. All rights reserved.
//

import UIKit

class GoogleTableViewController: UITableViewController {
    
    let alert = VMWAlertView()
    
    @IBOutlet weak var GooglePrivateKeyID: UITextField!
    @IBOutlet weak var GooglePrivateKey: UITextField!
    @IBOutlet weak var GoogleClientID: UITextField!
    @IBOutlet weak var GoogleProjectID: UITextField!
    @IBOutlet weak var GoogleInstanceID: UITextField!
    @IBOutlet weak var GoogleClientEmail: UITextField!
    @IBOutlet weak var GoogleSubmitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }

    @IBAction func doSubmit(_ sender: AnyObject) {
        do{
            let parser = GoogleInputParser()
            try parser.privateKeyIDParser(input:GooglePrivateKeyID.text)
            try parser.privateKeyParser(input: GooglePrivateKey.text)
            try parser.projectIDParser(input: GoogleProjectID.text)
            try parser.clientIDParser(input: GoogleClientID.text)
            try parser.clientEmailParser(input: GoogleClientEmail.text)
            try parser.instanceIDParser(input: GoogleInstanceID.text)
            
            PFCloud.callFunction(inBackground: "GoogleWatch", withParameters: ["privatekeyid" : GooglePrivateKeyID.text!, "privatekey" : GooglePrivateKey.text!, "clientid" : GoogleClientID.text!, "clientemail" : GoogleClientEmail.text!, "instanceid" : GoogleInstanceID.text!, "projectid" : GoogleProjectID.text!]){ (response, error) in
                
                if(error == nil){
                    
                    
                }else{                    
                    /* authentication failed no info recieved, error msg*/
                    self.present(
                        self.alert.showAlertWithOneButton(
                            title: "Error",
                            message: "Invalid Access Credentials",
                            actionButton: "OK"
                        ),
                        animated: true,
                        completion: nil
                    )
                }

            }
            
            
            
            
        } catch GoogleInputParserError.EmptyPrivateKeyID {
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Private Key ID is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        } catch GoogleInputParserError.EmptyPrivateKey{
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Private Key is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }catch GoogleInputParserError.EmptyProjectID{
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Project ID is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }catch GoogleInputParserError.EmptyClientID{
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Client ID is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }catch GoogleInputParserError.EmptyClientEmail{
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Client email is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }catch GoogleInputParserError.EmptyInstanceID{
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Instance ID is empty",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }catch let error as NSError {
            NSLog("Error with request: \(error)")
            self.present(
                self.alert.showAlertWithOneButton(
                    title: "Error",
                    message: "Unexpected Error",
                    actionButton: "OK"
                ),
                animated: true,
                completion: nil
            )
        }

    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
