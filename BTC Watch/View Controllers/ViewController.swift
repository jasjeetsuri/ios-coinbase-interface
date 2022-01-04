//------------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//------------------------------------------------------------------------------

import UIKit
import MSAL

/// 😃 A View Controller that will respond to the events of the Storyboard.

class ViewController: UIViewController, UITextFieldDelegate, URLSessionDelegate {
    
  let kTenantName = "b2cprod.onmicrosoft.com" // Your tenant name
  let kAuthorityHostName = "b2cprod.b2clogin.com" // Your authority host name
  let kClientID = "662225f9-fc44-42b9-b185-a2147720e3f1" // Your client ID from the portal when you created your application
  let kRedirectUri = "msauth.com.microsoft.identitysample.MSALiOS://auth" // Your application's redirect URI
  let kSignupOrSigninPolicy = "B2C_1_signin" // Your signup and sign-in policy you created in the portal
  let kEditProfilePolicy = "b2c_1_edit_profile" // Your edit policy you created in the portal
  let kResetPasswordPolicy = "b2c_1_reset" // Your reset password policy you created in the portal
  let kGraphURI = "https://fabrikamb2chello.azurewebsites.net/hello" // This is your backend API that you've configured to accept your app's tokens
  let kScopes: [String] = ["https://b2cprod.onmicrosoft.com/test/read"] // This is a scope that you've configured your backend API to look for.
    
    // DO NOT CHANGE - This is the format of OIDC Token and Authorization endpoints for Azure AD B2C.
    let kEndpoint = "https://%@/tfp/%@/%@"
    
    var applicationContext: MSALPublicClientApplication!
    public var accessToken: String?
    var webViewParamaters : MSALWebviewParameters?

    var window: UIWindow?
    // UI elements
    var loggingText: UITextView!
    var signInButton: UIButton!
    var signOutButton: UIButton!
    var callGraphButton: UIButton!
    var usernameLabel: UILabel!
    var editProfileButton: UIButton!
    var refreshTokenButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       /* do {
            
            let siginPolicyAuthority = try self.getAuthority(forPolicy: self.kSignupOrSigninPolicy)
            let editProfileAuthority = try self.getAuthority(forPolicy: self.kEditProfilePolicy)

            // Provide configuration for MSALPublicClientApplication
            // MSAL will use default redirect uri when you provide nil
            let pcaConfig = MSALPublicClientApplicationConfig(clientId: kClientID, redirectUri: kRedirectUri, authority: siginPolicyAuthority)
            pcaConfig.knownAuthorities = [siginPolicyAuthority, editProfileAuthority]
            
            self.applicationContext = try MSALPublicClientApplication(configuration: pcaConfig)
            //self.initWebViewParams()
            
        } catch {
            self.updateLoggingText(text: "Unable to create application \(error)")
        }*/
      initUI()

    }
    

  @objc func signInButton(_ sender: UIButton) {

    let myVar =  MyMSAL()
    myVar.SetupMSAL()
    MyVariables.webViewParamaters = MSALWebviewParameters(authPresentationViewController: self)
    self.interactiveLogin()

    
  }
  
  
  
  func interactiveLogin() {
        do {
            let authority = try getAuthority(forPolicy: MyVariables.kSignupOrSigninPolicy)

            
          let parameters = MSALInteractiveTokenParameters(scopes: MyVariables.kScopes, webviewParameters: MyVariables.webViewParamaters!)
            parameters.promptType = .selectAccount
            parameters.loginHint = "jasjeet@pm.me"
            parameters.authority = authority
            //parameters.webviewType = .wkWebView
        
            
          MyVariables.applicationContext.acquireToken(with: parameters) { (result, error) in
                
                guard let result = result else {
                  //MyVariables.updateLoggingText(text: "Could not acquire token: \(error ?? "No error informarion" as! Error)")
                  print(error)
                    return
                }
                
                //MyVariables.accessToken = result.accessToken
                MyVariables.token = result.accessToken
                MyVariables.userObjectId = result.uniqueId
                //self.updateLoggingText(text: "Access token is \(self.accessToken ?? "Empty")")
                /*self.signOutButton.isEnabled = true
                self.callGraphButton.isEnabled = true
                self.editProfileButton.isEnabled = true
                self.refreshTokenButton.isEnabled = true*/
            if (UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "apikey") == nil){
              UserDefaults.standard.set("", forKey: MyVariables.userObjectId! + "apikey")
            }
            if (UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "passphrase") == nil){
              UserDefaults.standard.set("", forKey: MyVariables.userObjectId! + "passphrase")
            }
            if (UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "secret") == nil){
              UserDefaults.standard.set("", forKey: MyVariables.userObjectId! + "secret")
            }
            
            if (UserDefaults.standard.string(forKey: MyVariables.userObjectId! + "currency") == nil)
            {
              UserDefaults.standard.set("GBP", forKey: MyVariables.userObjectId! + "currency")
              
            }
            self.showSecondViewController()
            
            }
        } catch {
          print("fail3")
            print(error)
        }
    }
    
  
   func showSecondViewController() {
     
     let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
     let homeView  = storyBoard.instantiateViewController(withIdentifier: "BTCTabBarController") as! BTCTabBarController
     homeView.modalPresentationStyle = .fullScreen
     self.present(homeView, animated: true, completion: nil)
     
  }
  

    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       /* if self.accessToken == nil {
            signOutButton.isEnabled = false
            callGraphButton.isEnabled = false
            editProfileButton.isEnabled = false
            refreshTokenButton.isEnabled = false
          
        }*/
    }
    
  override func viewDidAppear(_ animated: Bool) {
      
      if self.accessToken == nil {
          //authorizationButton()
        
      }
  }
  
    func getAccountByPolicy (withAccounts accounts: [MSALAccount], policy: String) throws -> MSALAccount? {
        
        for account in accounts {
            // This is a single account sample, so we only check the suffic part of the object id,
            // where object id is in the form of <object id>-<policy>.
            // For multi-account apps, the whole object id needs to be checked.
            if let homeAccountId = account.homeAccountId, let objectId = homeAccountId.objectId {
                if objectId.hasSuffix(policy.lowercased()) {
                    return account
                }
            }
        }
        return nil
    }
    

    
    func updateLoggingText(text: String) {
        DispatchQueue.main.async{
            print(text)
        }
    }
}


// Yoel: UI Helpers
extension ViewController {
    
    func initUI() {
    signInButton  = UIButton()
    signInButton.translatesAutoresizingMaskIntoConstraints = false
    signInButton.setTitle("Sign In", for: .normal)
    signInButton.setTitleColor(.blue, for: .normal)
    signInButton.addTarget(self, action: #selector(signInButton(_:)), for: .touchUpInside)

    self.view.addSubview(signInButton)

    signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    signInButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 340.0).isActive = true
    signInButton.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
    signInButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true

  

    self.view.backgroundColor =  UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
    }
}
