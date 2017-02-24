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
    
    /*variable for storing google credentials*/
    var google_credentials: [String: String]!
    var google_history_credentials: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* testing to see core data stored
        self.getGoogleHistory()
        print ("num of results = \(google_history_credentials.count)")
        for trans in google_history_credentials as NSMutableArray {
            //get the Key Value pairs (although there may be a better way to do that...
            print(trans)
        }
        */
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
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func storeGoogleHistory(){
        let history = GoogleHistoryStorage()
        do{
            try history.deleteHistoryRecord(privateKeyID: self.GooglePrivateKeyID.text!, privateKey: self.GooglePrivateKey.text! , clientID: self.GoogleClientID.text!, clientEmail: self.GoogleClientEmail.text!, projectID: self.GoogleProjectID.text!, instanceID: self.GoogleInstanceID.text!)
            try history.storeGoogleHistory(privateKeyID: self.GooglePrivateKeyID.text!, privateKey: self.GooglePrivateKey.text! , clientID: self.GoogleClientID.text!, clientEmail: self.GoogleClientEmail.text!, projectID: self.GoogleProjectID.text!, instanceID: self.GoogleInstanceID.text!)
        } catch GoogleCoreDataStorageError.DatabaseStoreError {
            NSLog("Could not save the history data due to database issue")
        } catch GoogleCoreDataStorageError.DatabaseDeleteError {
            NSLog("Fail to remove previous history data due to database issue")
        } catch {
            NSLog("Unexpected database issue")
        }
    }
    
    func getGoogleHistory(){
        let history = GoogleHistoryStorage()
        do{
            try google_history_credentials = history.getGoogleHistory()
        } catch GoogleCoreDataStorageError.DatabaseFetchError {
            NSLog("Could not get the history data due to database issue")
        } catch {
            NSLog("Unexpected database issue")
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
                    /*if can successfully access gcc, store credentials in core data*/
                    self.storeGoogleHistory()
                    let GoogleResult : GoogleResultViewController = GoogleView.instantiateViewController(withIdentifier: "GoogleResult") as! GoogleResultViewController
                    GoogleResult.hidesBottomBarWhenPushed = true
                    self.navigationController!.navigationBar.tintColor = UIColor.white
                    self.navigationController?.pushViewController(GoogleResult, animated: true)
                    
                    GoogleResult.response = response
                    
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
