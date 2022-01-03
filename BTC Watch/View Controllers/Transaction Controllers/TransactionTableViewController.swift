//
//  TransactionTableViewController.swift
//  BTC Watch
//
//  Created by Jas on 19/11/2017.
//  Copyright © 2017 Jastech Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class TransactionTableViewController: UITableViewController {
  var count:Int = 0
  var btc = [String]()
  var cost = [String]()
  var profit = [String]()
  var time = [String]()
  var value = [String]()
  var incoming = [String]()
  var gain = [String]()
  
  @IBOutlet var TransactionTable: UITableView!

  @objc func refresh(sender:AnyObject)
  {
      // Updating your data here...

    DispatchQueue.main.async {
        // Run UI Updates
      self.retrieveTransactions()
      
    }

    self.tableView.reloadData()
    self.refreshControl?.endRefreshing()
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    TransactionTable.rowHeight = 90
    TransactionTable.backgroundColor =  UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)

    //self.tableView.reloadData()
    //retrieveTransactions()
    //self.tableView.dataSource = self
    //self.TransactionTable.dataSource = self
    //self.TransactionTable.reloadData()
    //self.tableView.reloadData()
    TransactionTable.separatorColor = UIColor.darkGray
    UINavigationBar.appearance().barStyle = .black
    UITabBar.appearance().barStyle = .black
    
    
    self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)

    
    }

  
  override func viewDidAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.retrieveTransactions()
    self.TransactionTable.reloadData()
    //self.tableView.reloadData()
    
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return count
    }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if incoming[indexPath.row] == "true" {
  let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath as IndexPath) as! TransactionTableViewCell
          if count != 0 {
              cell.buyLbl.text = "Purchased"
              cell.valueLbl.text = "Value"
              cell.costLbl.text = "Cost"
              //cell.dateLbl.text = ""
              //cell.btcLbl.text = "BTC"
              cell.buyBtcValue.text = btc[indexPath.row] + " BTC"
              cell.valueAmount.text = value[indexPath.row]
              cell.costAmount.text = cost[indexPath.row]
              cell.dateTX.text = time[indexPath.row]
              cell.profitPercent.text = profit[indexPath.row]
              cell.selectionStyle = .none
            
            if gain[indexPath.row] == "true"{
              cell.profitPercent.textColor = UIColor.white
              cell.profitPercent.backgroundColor = UIColor(red: 10.0/255.0 , green:  220.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
            }
            if gain[indexPath.row] == "false"{
              cell.profitPercent.textColor = UIColor.white
              cell.profitPercent.backgroundColor = UIColor.red
            }
              cell.profitPercent.layer.masksToBounds = true
              cell.profitPercent.layer.cornerRadius = 7
              return cell
          }
    }
    if incoming[indexPath.row] == "false" {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CostTxTableViewCell", for: indexPath as IndexPath) as! CostTxTableViewCell
      if count != 0 {
        cell.sentLbl.text = "Sold"
        cell.costLbl.text = "Cost"
        cell.dateLbl.text = "Date:"
        //cell.btcLbl.text = "BTC"
        cell.sentBtc.text = btc[indexPath.row] + " BTC"
        cell.sentBtc.textColor = UIColor.red
        cell.costAmount.text = cost[indexPath.row]
        cell.costAmount.textColor = UIColor.red
        cell.dateValue.text = time[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
        return cell
      }
    }
    
    self.TransactionTable.reloadData()
    self.tableView.reloadData()
    return UITableViewCell()
    }
  
  func retrieveTransactions() {
    if UserDefaults.standard.string(forKey: "apikey") != ""{
      let secret = UserDefaults.standard.string(forKey: "secret")!
      let apikey = UserDefaults.standard.string(forKey: "apikey")!
      let passphrase = UserDefaults.standard.string(forKey: "passphrase")!
      
      let urlEncodedSecret = secret.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
      let fullUrl = "https://recurringbuy.azurewebsites.net/api/cbTransactions?code=LN0hapy1i1ZLmbZf6cvDJuS2Z12gZU1EsSCnTKDANB9eoV5pNVTqsA==&apikey=\(apikey)&passphrase=\(passphrase)&secret=\(urlEncodedSecret ?? "aa")&currency=" + UserDefaults.standard.string(forKey: "currency")!
      
      AF.request(fullUrl)
      .responseJSON { (responseData) -> Void in
        switch responseData.result {
          case let .success(responseData):
            let swiftyJsonVar = JSON(responseData)
          //print(swiftyJsonVar.arrayObject![2])
          self.count = swiftyJsonVar.count
          let json = JSON(responseData)
          self.btc.removeAll()
          self.cost.removeAll()
          self.profit.removeAll()
          self.time.removeAll()
          self.value.removeAll()
          self.gain.removeAll()
          self.incoming.removeAll()
          
          for (key, subJson) in json {
            //print(subJson["btc"])
            self.btc.append(subJson["btc"].stringValue)
            self.cost.append(subJson["cost"].stringValue)
            self.profit.append(subJson["profit"].stringValue)
            self.time.append(subJson["time"].stringValue)
            self.value.append(subJson["value"].stringValue)
            self.incoming.append(subJson["incoming"].stringValue)
            self.gain.append(subJson["gain"].stringValue)
          }
          let string = MyVariables.token
          print("Global variable:\(string ?? "aa")")
  
          
        case let .failure(error):
            print("fail")
          print("api key: " + UserDefaults.standard.string(forKey: "apikey")!)
          print("pp: " + UserDefaults.standard.string(forKey: "passphrase")!)
          print("secret: " + UserDefaults.standard.string(forKey: "secret")!)
          print("url encoded: " + urlEncodedSecret!)
          print("url: " + fullUrl)
        }
      }
    }
  }
  }


