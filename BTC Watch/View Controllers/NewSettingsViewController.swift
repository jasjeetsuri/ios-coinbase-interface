//
//  NewSettingsViewController.swift
//  BTC Watch
//
//  Created by Jas on 18/11/2017.
//  Copyright © 2017 Jastech Ltd. All rights reserved.
//

import UIKit

var gradientLayer = CALayer()

class NewSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  //MARK: Properties
  
  var xpubSetting: String?
  var apikey: String?
  var passphrase: String?
  var secret: String?
  

  
  //MARK: Outlets
  
 // @IBOutlet weak var xpubSetting: UITextField!
  //@IBOutlet weak var myTable: UITableView!
  @IBOutlet weak var tableView: UITableView!
  
  //MARK: Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //UINavigationBar.appearance().barStyle = .default
    //self.xpubSetting = "test"//UserDefaults.standard.string(forKey: "xpub")
    
    self.apikey = UserDefaults.standard.string(forKey: "apikey")
    self.passphrase = UserDefaults.standard.string(forKey: "passphrase")
    self.secret = UserDefaults.standard.string(forKey: "secret")
    
    
    //tableView.reloadData()
    //tableView.backgroundColor =  UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
    tableView.separatorColor = UIColor.darkGray
    
  }

  override func viewDidAppear(_ animated: Bool) {
    //tableView.reloadData()
    gradientLayer.isHidden = true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}


extension NewSettingsViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    if(textField.accessibilityIdentifier == "apikey"){
      let defaults = UserDefaults.standard
      if let text = textField.text {
        defaults.set(text, forKey: "apikey")
      }
      apikey = textField.text
    }
    if(textField.tag == 2){
      let defaults = UserDefaults.standard
      if let text = textField.text {
        defaults.set(text, forKey: "passphrase")
      }
      passphrase = textField.text
    }
    if(textField.tag == 3){
      let defaults = UserDefaults.standard
      if let text = textField.text {
        defaults.set(text, forKey: "secret")
      }
      secret = textField.text
    }
  }
  //delegate method
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    //self.xpubSetting.resignFirstResponder()
    return true
  }
  


  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    /*if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: XPubSettingTableViewCell.self), for: indexPath as IndexPath) as! XPubSettingTableViewCell
      cell.xpubTextField.delegate = self
      if (UserDefaults.standard.string(forKey: "apikey") == "" ){
        cell.xpubTextField.text = "test"
      } else
      {
        cell.xpubTextField.text = "test"//cell.xpubTextField.text = UserDefaults.standard.string(forKey: "xpub")!
      }
      cell.xpubTextField.placeholder = "Enter your api key"
      //cell.xpubSettingLabel.text = "Enter xpub"
      cell.xpubTextField.tag = 0
      cell.xpubTextField.autocorrectionType = UITextAutocorrectionType.no
      cell.xpubTextField.clearButtonMode = UITextField.ViewMode.whileEditing
      cell.xpubTextField.returnKeyType = UIReturnKeyType.done
      cell.backgroundColor = UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
      return(cell)
    }*/
    /*if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HeadingTableViewCell.self)) as! HeadingTableViewCell
      cell.HeadingDisplayLabel.text = "Coinbase API Key"

      cell.backgroundColor = UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
      
      return(cell)
    }*/
  
    
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ApiKeyTableViewCell.self)) as! ApiKeyTableViewCell
      if (UserDefaults.standard.string(forKey: "apikey") == "" ){
        cell.apiKeyTextField.text = ""
      } else
      {
        cell.apiKeyTextField.text = UserDefaults.standard.string(forKey: "apikey")!
      }
      cell.apiKeyTextField.placeholder = "Enter your api key"
      cell.apiKeyLabel.text = "API Key"
      cell.apiKeyTextField.tag = 1
      cell.apiKeyTextField.delegate = self
      cell.backgroundColor = UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
      return(cell)
    }

    if indexPath.row == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PassphraseTableViewCell.self)) as! PassphraseTableViewCell
      if (UserDefaults.standard.string(forKey: "passphrase") == "" ){
        cell.passphraseTextField.text = ""
      } else
      {
        cell.passphraseTextField.text = UserDefaults.standard.string(forKey: "passphrase")!
      }
      cell.passphraseTextField.placeholder = "Enter your api key passphrase"
      cell.passphraseLabel.text = "Passphrase"
      cell.passphraseTextField.tag = 2
      cell.passphraseTextField.delegate = self
      cell.backgroundColor = UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
      return(cell)
    }
    
    if indexPath.row == 2 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SecretSettingTableViewCell.self)) as! SecretSettingTableViewCell
      if (UserDefaults.standard.string(forKey: "secret") == "" ){
        cell.secretTextField.text = ""
      } else
      {
        cell.secretTextField.text = UserDefaults.standard.string(forKey: "secret")!
      }
      cell.secretTextField.placeholder = "Enter your secret"
      cell.secretLabel.text = "Secret"
      cell.secretTextField.tag = 3
      cell.secretTextField.delegate = self
      cell.backgroundColor = UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
      return(cell)
    }
    if indexPath.row == 3 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CurrencySettingTableViewCell.self)) as! CurrencySettingTableViewCell
      cell.currencySettingLabel.text = "Currency"
      if (UserDefaults.standard.string(forKey: "currency") == nil ) {
        cell.currencySettingCodeDisplayLabel.text = "GBP"
      } else {
        cell.currencySettingCodeDisplayLabel.text = UserDefaults.standard.string(forKey: "currency")!
      }
      cell.backgroundColor = UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
      
      return(cell)
    }
  
    return UITableViewCell()
  }
  
  // method to run when table view cell is tapped
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    // Segue to the second view controller
    if indexPath.row == 3 {
      self.performSegue(.showCurrencySelection, sender: self)
    }
  }
}



