//
//  CreateProperty2ViewController.swift
//  iRent
//
//  Created by Arthur Ataide on 2020-08-20.
//  Copyright © 2020 Jose Smith Marmolejos & Arthur Ataide. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CreateProperty2ViewController: UIViewController {
    
    let cellIdentifier = "cell"
    let features = ["Heating","Air Conditioning", "Laundry", "Fireplace","Balcony"]
    @IBOutlet weak var bedroomTextField: UITextField!
    @IBOutlet weak var bathroomTextField: UITextField!
    @IBOutlet weak var parkingSpotTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func bedroomChanged(_ sender: UIStepper) {
        bedroomTextField.text = String(Int(sender.value))
    }
    
    @IBAction func bathroomChanged(_ sender: UIStepper) {
        bathroomTextField.text = String(Int(sender.value))
    }
    
    @IBAction func parkingSpotChanged(_ sender: UIStepper) {
        parkingSpotTextField.text = String(Int(sender.value))
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        if checkFields(){
            AppDelegate.shared().property.rooms = bedroomTextField.text!
            AppDelegate.shared().property.bathrooms = bathroomTextField.text!
            AppDelegate.shared().property.parkingSpot = parkingSpotTextField.text!
            
            let alert = UIAlertController(title: "Property", message:"Do you want to post this property?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Yes"), style: .default,handler: { alert -> Void in
                self.saveOnFirebase()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "No"), style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func saveOnFirebase(){
        if let user = Auth.auth().currentUser{
            let property = ["title":AppDelegate.shared().property.title,
                            "description":AppDelegate.shared().property.description,
                            "type":AppDelegate.shared().property.type,
                            "address":AppDelegate.shared().property.address,
                            "country":AppDelegate.shared().property.country,
                            "province":AppDelegate.shared().property.province,
                            "city":AppDelegate.shared().property.city,
                            "postalCode":AppDelegate.shared().property.postalCode,
                            "location":AppDelegate.shared().property.location,
                            "price":AppDelegate.shared().property.price,
                            "created":Common.getDateTime("DATE") + " " + Common.getDateTime("TIME"),
                            "heating":AppDelegate.shared().property.heating,
                            "balcony":AppDelegate.shared().property.balcony,
                            "fireplace":AppDelegate.shared().property.fireplace,
                            "airConditioning":AppDelegate.shared().property.airConditioning,
                            "laundry":AppDelegate.shared().property.laundry,
                            "parkingSpots":AppDelegate.shared().property.parkingSpot,
                            "rooms":AppDelegate.shared().property.rooms,
                            "bathrooms":AppDelegate.shared().property.bathrooms,
                            "status":"1",
            ]
            
            guard let key = ref.child("property").child(user.uid).childByAutoId().key else { return }
            ref.child("property").child(user.uid).child(key).setValue(property)
        }
    }
    
    func checkFields() -> Bool{
        if (bedroomTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showMessage("Post", "Bedroom is required", "OK")
            bedroomTextField.becomeFirstResponder()
            return false
        }
        
        if (bathroomTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showMessage("Post", "Bathroom is required", "OK")
            bathroomTextField.becomeFirstResponder()
            return false
        }
        
        if (parkingSpotTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            showMessage("Post", "Parking Spot is required", "OK")
            parkingSpotTextField.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    func showMessage(_ title:String, _ message:String, _ actionMessage:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(actionMessage, comment: actionMessage), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

extension CreateProperty2ViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = features[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Features"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            AppDelegate.shared().property.heating = "1"
        case 1:
            AppDelegate.shared().property.airConditioning = "1"
        case 2:
            AppDelegate.shared().property.laundry = "1"
        case 3:
            AppDelegate.shared().property.fireplace = "1"
        case 4:
            AppDelegate.shared().property.balcony = "1"
        default:
            print("default")
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            AppDelegate.shared().property.heating = "0"
        case 1:
            AppDelegate.shared().property.airConditioning = "0"
        case 2:
            AppDelegate.shared().property.laundry = "0"
        case 3:
            AppDelegate.shared().property.fireplace = "0"
        case 4:
            AppDelegate.shared().property.balcony = "0"
        default:
            print("default")
        }
    }
    
}