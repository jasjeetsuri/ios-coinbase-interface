//
//  TransactionApi.swift
//  BTC Watch
//
//  Created by Jas on 19/11/2017.
//  Copyright © 2017 Jastech Ltd. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum TransactionError: Error, LocalizedError {
case pathNotPresent
case noData

var localizedDescription: String {
  switch self {
  case .pathNotPresent:
    return NSLocalizedString("path_not_present_error", value: "No path present for request", comment: "No Path present error")
  case .noData:
    return NSLocalizedString("no_data_error", value: "No Data in response", comment: "No data in response error")
  }
}
}

class TransactionApi {
  
  // MARK: Constants
  
  //private static let apiKey = "ZXXscsYJbbo/UYj68exi9wqSGwc7jIOM5rjyIvV3MVTUDTyzVcVI7Q=="
  
  //RequestGenerator generates a URLRequest ready to be sent, additional API calls can be added by extending the switch statements.
  
  enum RequestRouter: URLRequestConvertible  {
    
    case retrieveTransactions
    
    func asURLRequest() throws -> URLRequest {
      
      let baseUrl = "https://recurringbuy.azurewebsites.net"
      
      var route: (path: String, parameters: [String: Any], method: HTTPMethod, secure: Bool) {
        switch self {
        case .retrieveTransactions:
          let params: [String : Any] = ["code" : "LN0hapy1i1ZLmbZf6cvDJuS2Z12gZU1EsSCnTKDANB9eoV5pNVTqsA", "apikey" : "ad22a179fd437b964837d8f6d33fc961", "passphrase" : "wqe8ukkb9oh", "secret" :"TKpzr3QY55d4zgmdgoe5XbfGKv7A99d93q08/5qoD2UyfCCrML3utgWwC7h9X2RX+3SGNcqe6k5IIHmWyElfDA==", "currency" : UserDefaults.standard.string(forKey: "currency")!]
          return (baseUrl + "/api/cbTransactions", params, .get, false)
          
          //case .loginStatus:
          //return (baseUrl + "/api/balance", [:], .get, false)
        }
      }
      guard let path = URL(string: route.path) else { throw TransactionError.pathNotPresent }
      
      var theURLRequest = URLRequest(url: path, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
      
      theURLRequest.httpMethod = route.method.rawValue
      
      // add custom headers for authentication.
      //      if route.secure {
      //        let defaultHeaders = TransactionApi.createSecureHeaders(path: self.apiPath)
      //        for header in defaultHeaders {
      //          theURLRequest.setValue(header.1 as? String, forHTTPHeaderField: header.0 as! String)
      //          //print("Header: \(header.0) Value: \(header.1)")
      //        }
      //      }
      
      if route.method == .get {
        theURLRequest.httpBody = nil
      }
      
      //return theURLRequest as URLRequest
      let encoding: ParameterEncoding = URLEncoding.default
      
      
      //      switch self {
      //      case .login:
      //        encoding = JSONEncoding.default
      //      case .getCatalogueFile, .getOrderHistory:
      //        theURLRequest.timeoutInterval = 120 //longer timeout for large file downloads. the server takes too long to reply
      //      default:
      //        break
      //      }
      
      if route.parameters.count > 0 {
        return try encoding.encode(theURLRequest, with: route.parameters)
      }
      return try encoding.encode(theURLRequest, with: nil)
    }
    
    var apiPath: String {
      switch self {
      default:
        return ""
      }
    }
  }
  
  static let instance: TransactionApi = TransactionApi()
  
  var requestManager: Alamofire.Session!
  
  init() {
    
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 70 // seconds
    configuration.timeoutIntervalForResource = 70
    configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    self.requestManager = Alamofire.Session(configuration: configuration)
  }
  
  // MARK: Methods
  
  //  class func createSecureHeaders(path: String) -> [AnyHashable : Any] {
  //    var defaultHeaders = TransactionApi.instance.requestManager.session.configuration.httpAdditionalHeaders ?? [:]
  //    defaultHeaders["Accept"] = "application/json"
  //    defaultHeaders["Content-Type"] = "application/json"
  //    let dateString = createDateHeader()
  //    defaultHeaders["Date"] = dateString
  //    let xauth = createXAuthHeader(path: path, date: dateString)
  //    defaultHeaders["X-Auth"] = xauth
  //    //print(xauth)
  //    return defaultHeaders
  //  }
  
  //  class func createXAuthHeader(path: String, date: String) -> String? {
  //    let hmacKey = TransactionApiKeys.bearerToken
  //    let baseString = path + " " + date + " "
  //    if let authData = AuthorizationHelper.hmac(forKey: hmacKey, andData: baseString) {
  //      let authString = authData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
  //      return authString
  //    }
  //    return nil
  //  }
  //
  //  class func createDateHeader() -> String {
  //    var dateString = Formatter.sqlDateString(fromDate: Date())
  //    dateString = dateString.replacingOccurrences(of: " pm", with: "")
  //    dateString = dateString.replacingOccurrences(of: " am", with: "")
  //    return dateString
  //  }
  
  class func cancelAllOperations() {
    if #available(iOS 9.0, *) {
      TransactionApi.instance.requestManager.session.getAllTasks { tasks in
        tasks.forEach { $0.cancel() }
      }
    } else {
      TransactionApi.instance.requestManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
        dataTasks.forEach { $0.cancel() }
        uploadTasks.forEach { $0.cancel() }
        downloadTasks.forEach { $0.cancel() }
      }
    }
  }
}



extension TransactionApi {
  
  class func retrieveTransactions(withSuccess success: @escaping (_ transaction: Transaction) -> Void, failure: @escaping (_ error: Error?, _ httpCode: Int?) -> Void) {
    let router = RequestRouter.retrieveTransactions
    var result = [[String:AnyObject]]()
    
    TransactionApi.instance.requestManager.request(router).responseData{ (responseData) in
      switch responseData.result {
      case let .success(responseData):
        let response = JSON(responseData)
        if let data = response["data"].arrayObject {
          print(data)
          result = data as! [[String:AnyObject]]}
          
      case let .failure(error):
        //failure(error, responseData)
        return
      }
    }
  }
}


