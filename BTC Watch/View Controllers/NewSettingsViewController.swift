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
  
  //@IBOutlet weak var xpubSetting: UITextField!
  //@IBOutlet weak var myTable: UITableView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var signOutLabel: UILabel!
  
  //MARK: Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //UINavigationBar.appearance().barStyle = .default
    //self.xpubSetting = "test"//UserDefaults.standard.string(forKey: "xpub")
    
    self.apikey = UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "apikey")
    self.passphrase = UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "passphrase")
    self.secret = UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "secret")
    
    
    //tableView.reloadData()
    //tableView.backgroundColor =  UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
    tableView.separatorColor = UIColor.darkGray
    self.hideKeyboardWhenTappedAround() 
    
  }

  override func viewDidAppear(_ animated: Bool) {
    tableView.reloadData()
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
        defaults.set(text, forKey: MyVariables.userObjectId! + "apikey")
      }
      apikey = textField.text
    }
    if(textField.tag == 2){
      let defaults = UserDefaults.standard
      if let text = textField.text {
        defaults.set(text, forKey: MyVariables.userObjectId! + "passphrase")
      }
      passphrase = textField.text
    }
    if(textField.tag == 3){
      let defaults = UserDefaults.standard
      if let text = textField.text {
        defaults.set(text, forKey: MyVariables.userObjectId! + "secret")
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
    return 7
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    /*if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: XPubSettingTableViewCell.self), for: indexPath as IndexPath) as! XPubSettingTableViewCell
      cell.xpubTextField.delegate = self
      if (UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "apikey") == "" ){
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
      if (UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "apikey") == "" ){
        cell.apiKeyTextField.text = ""
      } else
      {
        cell.apiKeyTextField.text = UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "apikey")!
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
      if (UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "passphrase") == "" ){
        cell.passphraseTextField.text = ""
      } else
      {
        cell.passphraseTextField.text = UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "passphrase")!
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
      if (UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "secret") == "" ){
        cell.secretTextField.text = ""
      } else
      {
        cell.secretTextField.text = UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "secret")!
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
      if (UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "currency") == nil ) {
        cell.currencySettingCodeDisplayLabel.text = "GBP"
      } else {
        cell.currencySettingCodeDisplayLabel.text = UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "currency")!
      }
      cell.backgroundColor = UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
      
      return(cell)
    }
    if indexPath.row == 4 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecurrngBuyTableViewCell.self)) as! RecurrngBuyTableViewCell
      cell.menuLabel.text = "Setup recurring buy"
      cell.backgroundColor = UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
      
      return(cell)
    }
    
    if indexPath.row == 5 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BlankTableViewCell.self)) as! BlankTableViewCell

      cell.backgroundColor = UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
      
      return(cell)
    }
    if indexPath.row == 6 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SignOutTableViewCell.self)) as! SignOutTableViewCell
      cell.signOutLabel.text = "Sign out"

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
    
    if indexPath.row == 6 {
      //self.performSegue(.showCurrencySelection, sender: self)
      let myVar =  MyMSAL()
      myVar.signOut()
     print("signing out")
      let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let homeView  = storyBoard.instantiateViewController(withIdentifier: "signInPage") as! UIViewController
      homeView.modalPresentationStyle = .fullScreen
      self.present(homeView, animated: true, completion: nil)
    }
    
  }
}
