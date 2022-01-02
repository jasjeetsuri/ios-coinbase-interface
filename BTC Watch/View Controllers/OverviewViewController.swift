//
//  OverviewViewController.swift
//  BTC Watch
//
//  Created by Jas on 18/11/2017.
//  Copyright © 2017 Jastech Ltd. All rights reserved.
//

import UIKit
import Alamofire

class OverviewViewController: UIViewController {
  
  @IBOutlet weak var BtcBalance: UILabel!
  @IBOutlet weak var rateGBP: UILabel! // Rename this and the others rateGBPLabel for better naming
  @IBOutlet weak var rateUSD: UILabel!
  @IBOutlet weak var rateEUR: UILabel!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var totalValue: UILabel!
  @IBOutlet weak var invalidXpub: UILabel!
  @IBOutlet weak var refreshBtn: UIButton!
  @IBOutlet weak var Profit: UILabel!
  @IBOutlet weak var btcIcon: UIImageView!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var exchangeRate1Lbl: UILabel!
  @IBOutlet weak var exchangeRate2Lbl: UILabel!
  @IBOutlet weak var exchangeRate3Lbl: UILabel!
  //@IBOutlet weak var selectedCurrency: UILabel!
  
  // MARK: - View Life Cycle
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UINavigationBar.appearance().barStyle = .black
    UITabBar.appearance().barStyle = .black
    //preferredStatusBarStyle = .lightContent
    // UI Setup
    spinner.style = UIActivityIndicatorView.Style.whiteLarge
    //spinner.color = UIColor.gray
    //containerView.backgroundColor = Colours.darkGrey
    //btcIcon.isHidden = true
    spinner.hidesWhenStopped = true

    self.retrieveBalance()
  }

  
  func retrieveBalance() {
    guard UserDefaults.standard.string(forKey: "apikey") != "" else {
      self.resetLabels()
      self.invalidXpub.text = "Add API Key"
      return
    }
    
    self.startLoading()
    Networking.retrieveBalance(withSuccess: { (balance) in
      self.setLabels(withBTC: balance)
      //self.btcIcon.isHidden = false
      //let delayInSeconds = 1.0
      //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
        self.endLoading()
      //}
    }) { (error, httpCode) in
      self.resetLabels()
      self.invalidXpub.text = "Invalid xpub"
    }
  }

  
 /* override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(OverviewViewController.retrieveBalance), name: .UIApplication.willEnterForegroundNotification, object: nil)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: .UIApplication.willEnterForegroundNotification, object: nil)
  }*/
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
  
  func resetLabels() {
    //self.BtcBalance.text = "-"
    //self.totalValue.text = "-"
    //self.Profit.text = "-"
    //self.rateGBP.text = "-"
    //self.rateUSD.text = "-"
    //self.rateEUR.text = "-"
    endLoading()
  }
  
  func setLabels(withBTC balance: BTC) {
    self.invalidXpub.text = ""
    self.BtcBalance.text = String(balance.Total_BTC)
    self.totalValue.text = String(balance.Total_Fiat) + " " + UserDefaults.standard.string(forKey: "currency")!
    self.rateGBP.text = String(balance.BTC_to_GBP) + " " + UserDefaults.standard.string(forKey: "currency")!
    if UserDefaults.standard.string(forKey: "currency") == "GBP"
      {
        self.rateEUR.text = String(balance.BTC_to_EUR) + " EUR"
        self.rateUSD.text = String(balance.BTC_to_USD) + " USD"
        //self.rateEUR.text = String(balance.BTC_to_GBP) + " GBP"
        self.exchangeRate1Lbl.text = "BTC/" + UserDefaults.standard.string(forKey: "currency")!
        self.exchangeRate1Lbl.text = "BTC/GBP"
        self.exchangeRate2Lbl.text = "BTC/EUR"
        self.exchangeRate3Lbl.text = "BTC/USD"
      }
    if UserDefaults.standard.string(forKey: "currency") == "USD" {
      //self.rateUSD.text = ""
      self.exchangeRate1Lbl.text = "BTC/" + UserDefaults.standard.string(forKey: "currency")!
      self.exchangeRate2Lbl.text = "BTC/GBP"
      self.rateEUR.text = String(balance.BTC_to_GBP) + " GBP"
      self.exchangeRate3Lbl.text = "BTC/EUR"
      self.rateUSD.text = String(balance.BTC_to_EUR) + " EUR"
      self.rateGBP.text = String(balance.BTC_to_USD) + " USD"
    }
    if UserDefaults.standard.string(forKey: "currency") == "EUR" {
      self.exchangeRate1Lbl.text = "BTC/" + UserDefaults.standard.string(forKey: "currency")!
      self.exchangeRate2Lbl.text = "BTC/GBP"
      self.rateEUR.text = String(balance.BTC_to_GBP) + " GBP"
      self.exchangeRate3Lbl.text = "BTC/EUR"
      self.rateUSD.text = String(balance.BTC_to_USD) + " USD"
      self.rateGBP.text = String(balance.BTC_to_EUR) + " EUR"
    }
    
    if UserDefaults.standard.string(forKey: "currency") != "EUR" && UserDefaults.standard.string(forKey: "currency") != "GBP" && UserDefaults.standard.string(forKey: "currency") != "USD" {
      self.exchangeRate1Lbl.text = "BTC/" + UserDefaults.standard.string(forKey: "currency")!
      self.rateGBP.text = String(balance.BTC_to_GBP) + " " + UserDefaults.standard.string(forKey: "currency")!
      
      self.exchangeRate2Lbl.text = "BTC/USD"
      self.rateEUR.text = String(balance.BTC_to_USD) + " USD"
      
      self.exchangeRate3Lbl.text = ""
      self.rateUSD.text = ""
      
    }
    
    if balance.isUp == "True"{
    self.Profit.text = "+" + String(balance.Profit) + " " + UserDefaults.standard.string(forKey: "currency")!
      self.Profit.textColor = UIColor.green
    }
    if balance.isUp == "False"{
      self.Profit.text = String(balance.Profit) + " " + UserDefaults.standard.string(forKey: "currency")!
      self.Profit.textColor = UIColor.red
    }
  }
  
  func startLoading() {
    refreshBtn.isHidden = true
    self.invalidXpub.text = ""
    spinner.startAnimating()
  }
  
  func endLoading() {
    self.spinner.stopAnimating()
    self.refreshBtn.isHidden = false
  }
  
  // MARK: Actions
  
  @IBAction func refresh(_ sender: UIButton) {
    self.retrieveBalance()
  }
}
