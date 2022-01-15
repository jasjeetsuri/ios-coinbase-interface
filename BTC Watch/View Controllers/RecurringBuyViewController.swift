//
//  RecurringBuyViewController.swift
//  BTC Watch
//
//  Created by Jas on 14/01/2022.
//  Copyright © 2022 Jastech Ltd. All rights reserved.
//

import Foundation
import UIKit

class RecurringBuyViewController: UIViewController {
  
  //MARK: Constants
  
  @IBOutlet weak var tableView: UITableView!
  //MARK: Outlets
  
  
  //@IBOutlet weak var settingsBackButton: UINavigationItem!
  //MARK: Properties
  var amount: String?
  var startDate: String?
  var frequency: String?
  var currency: String?
  
  //MARK: Methods
  let freqArr = ["Daily", "Weekly", "Bi-weekly", "Monthly"]
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
    tableView.separatorColor = UIColor.darkGray
    //datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
    //settingsBackButton.Uol
  }
  
  // MARK: Actions
  
  @IBAction func EnabledButton(_ sender: UISwitch) {
    
    
    if sender.isOn == true {
      print("toggle on, setting up background buy process")
      if (UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "amount") != nil && UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "frequency") != nil && UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "date") != nil){
        
        print("amount: " + UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "amount")! + ", start date: " + UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "date")! + " frequency: " + UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "frequency")!)
      } else{
        print("incomomplete setup")
      }
      
    } else {
      print("toggle off, disabling background buy process")
    }
    
  }
  
  @IBAction func datePickerDidChange(_ sender: UIDatePicker) {
    let defaults = UserDefaults.standard
    let formatter3 = DateFormatter()
    formatter3.dateFormat =  "MM/dd/yyyy, hh:mm aa"
    let myDate = formatter3.string(from: sender.date)
    defaults.set(myDate, forKey: MyVariables.userObjectId! + "date")
    
    
    /*dateFormatter.dateFormat =  "MM/dd/YYYY, HH:mm a"
    let myDate = sender.date.formatted(ISO8601DateFormatter)
    //.getFormattedDate(format: "yyyy-MM-dd HH:mm:ss")
    defaults.set(myDate, forKey: MyVariables.userObjectId! + "date")  //as! Date
    //print("date:" + myDate.formatted())
    
    startDate = myDate*/
    
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                  inComponent component: Int) {
    let myFreq = freqArr[row]
    print(myFreq)
    frequency = myFreq
    let defaults = UserDefaults.standard
    defaults.set(row, forKey: MyVariables.userObjectId! + "frequency")
  }
  

  
  
}



extension RecurringBuyViewController: UITextFieldDelegate {
  @IBAction func textFieldDidChange(_ sender: UITextField) {
    if(sender.tag == 1){
      let defaults = UserDefaults.standard
      if let text = sender.text {
        defaults.set(text, forKey: MyVariables.userObjectId! + "amount")
        print(text)
      }
      amount = sender.text
    }
  }
}





//delegate method
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
  textField.resignFirstResponder()
  //self.xpubSetting.resignFirstResponder()
  return true
}

extension RecurringBuyViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecurringAmountTableViewCell.self)) as! RecurringAmountTableViewCell
      cell.amountLabel.text = "Amount (" + UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "currency")! + ")"
      cell.amountText.textColor = UIColor.white
      cell.backgroundColor = UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
      cell.amountText.tag = 1
      if (UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "amount") == nil ){
        cell.amountText.text = ""
      } else
      {
        cell.amountText.text = UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "amount")!
      }
      cell.amountText.placeholder = "Enter amount to buy"
    
      return(cell)
    }
    if indexPath.row == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StartDateTableViewCell.self)) as! StartDateTableViewCell//StartDateTableViewCell
      cell.startDateLabel.text = "Start Date"
      cell.datePicker.setValue(UIColor.white, forKeyPath: "textColor")
      
      if (UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "date") == nil ){
        //cell.datePicker.text = ""
      } else
      {
        let dateString = UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "date")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "MM/dd/yyyy, hh:mm aa"
        let date = dateFormatter.date(from: dateString!)
        cell.datePicker.date = date!
        
        
        // cell.datePicker.date  1/15/2022, 4:00 PM
      }
      
      
      cell.backgroundColor = UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
      return(cell)
    }
    
    if indexPath.row == 2 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FrequencyTableViewCell.self)) as! FrequencyTableViewCell
      cell.frequencyLabel.text = "Frequency"
      cell.backgroundColor = UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
      
      if (UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "frequency") == nil ){
        cell.frequencyPicker.selectRow(0, inComponent: 0, animated: true)
      } else
      {
        let rowNum = UserDefaults.standard.integer(forKey: MyVariables.userObjectId! + "frequency")
        cell.frequencyPicker.selectRow(rowNum, inComponent: 0, animated: true)
      }
      
      
      return(cell)
    }
    
    if indexPath.row == 3 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecurringBuyEnabledTableViewCell.self)) as! RecurringBuyEnabledTableViewCell
      cell.enabledLabel.text = "Enabled"
      cell.backgroundColor = UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
      return(cell)
    }
    return UITableViewCell()
  }
  
}


extension RecurringBuyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 4
  }
  
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  
  
  //func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    
    
    var label = UILabel()
    if let v = view {
      label = v as! UILabel
    }
    label.font = UIFont (name: "Helvetica Neue", size: 17)
    label.text =  freqArr[row]
    label.textColor = UIColor.white
    label.textAlignment = .center
    return label
  }
  
}

