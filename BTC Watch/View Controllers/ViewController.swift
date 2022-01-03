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
        do {
            
            let siginPolicyAuthority = try self.getAuthority(forPolicy: self.kSignupOrSigninPolicy)
            let editProfileAuthority = try self.getAuthority(forPolicy: self.kEditProfilePolicy)

            // Provide configuration for MSALPublicClientApplication
            // MSAL will use default redirect uri when you provide nil
            let pcaConfig = MSALPublicClientApplicationConfig(clientId: kClientID, redirectUri: kRedirectUri, authority: siginPolicyAuthority)
            pcaConfig.knownAuthorities = [siginPolicyAuthority, editProfileAuthority]
            
            self.applicationContext = try MSALPublicClientApplication(configuration: pcaConfig)
            self.initWebViewParams()
            
        } catch {
            self.updateLoggingText(text: "Unable to create application \(error)")
        }
      initUI()

    }
    
    func initWebViewParams() {
        self.webViewParamaters = MSALWebviewParameters(authPresentationViewController: self)
    }
    

  @objc func signInButton(_ sender: UIButton) {
    //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    //let homeView  = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    //let myVar =  MyMSAL.SetupMSAL(homeView)
    //myVar.SetupMSAL(vc: self)
    
  }
  
  
  @objc func authorizationButton() {
        do {
            let authority = try self.getAuthority(forPolicy: self.kSignupOrSigninPolicy)

            
            let parameters = MSALInteractiveTokenParameters(scopes: kScopes, webviewParameters: self.webViewParamaters!)
            parameters.promptType = .selectAccount
            parameters.loginHint = "jasjeet@pm.me"
            parameters.authority = authority
            //parameters.webviewType = .wkWebView
        
            
            applicationContext.acquireToken(with: parameters) { (result, error) in
                
                guard let result = result else {
                    self.updateLoggingText(text: "Could not acquire token: \(error ?? "No error informarion" as! Error)")
                    return
                }
                
                self.accessToken = result.accessToken
                MyVariables.token = result.accessToken
                self.updateLoggingText(text: "Access token is \(self.accessToken ?? "Empty")")
                /*self.signOutButton.isEnabled = true
                self.callGraphButton.isEnabled = true
                self.editProfileButton.isEnabled = true
                self.refreshTokenButton.isEnabled = true*/
              
                self.showSecondViewController()
            }
        } catch {
            self.updateLoggingText(text: "Unable to create authority \(error)")
        }
    }
    
  
   func showSecondViewController() {
     
     let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
     let homeView  = storyBoard.instantiateViewController(withIdentifier: "BTCTabBarController") as! BTCTabBarController
     homeView.modalPresentationStyle = .fullScreen
     self.present(homeView, animated: true, completion: nil)
     
  }
  

    
    func refreshToken() -> String{
        
        do {
            
            let authority = try self.getAuthority(forPolicy: self.kSignupOrSigninPolicy)

            guard let thisAccount = try self.getAccountByPolicy(withAccounts: applicationContext.allAccounts(), policy: kSignupOrSigninPolicy) else {
                self.updateLoggingText(text: "There is no account available!")
              return "There is no account available!"
            }
            
            let parameters = MSALSilentTokenParameters(scopes: kScopes, account:thisAccount)
            parameters.authority = authority
            self.applicationContext.acquireTokenSilent(with: parameters) { (result, error) in
                if let error = error {
                    
                    let nsError = error as NSError
                    
                    // interactionRequired means we need to ask the user to sign-in. This usually happens
                    // when the user's Refresh Token is expired or if the user has changed their password
                    // among other possible reasons.
                    
                    if (nsError.domain == MSALErrorDomain) {
                        
                        if (nsError.code == MSALError.interactionRequired.rawValue) {
                            
                            // Notice we supply the account here. This ensures we acquire token for the same account
                            // as we originally authenticated.
                            
                            let parameters = MSALInteractiveTokenParameters(scopes: self.kScopes, webviewParameters: self.webViewParamaters!)
                            parameters.account = thisAccount
                            
                            self.applicationContext.acquireToken(with: parameters) { (result, error) in
                                
                                guard let result = result else {
                                    self.updateLoggingText(text: "Could not acquire new token: \(error ?? "No error informarion" as! Error)")
                                    return
                                }
                                
                                self.accessToken = result.accessToken
                                self.updateLoggingText(text: "Access token is \(self.accessToken ?? "empty")")
                              
                            }
                            return
                        }
                    }
                    
                    self.updateLoggingText(text: "Could not acquire token: \(error)")
                    return
                }
                
                guard let result = result else {
                    
                    self.updateLoggingText(text: "Could not acquire token: No result returned")
                    return
                }
                
                self.accessToken = result.accessToken
              MyVariables.token = result.accessToken
                self.updateLoggingText(text: "Refreshing token silently")
                self.updateLoggingText(text: "Refreshed access token is \(self.accessToken ?? "empty")")
                return 
            }
        } catch {
            self.updateLoggingText(text: "Unable to construct parameters before calling acquire token \(error)")
        }
      return self.accessToken!
    }
    
    
    @objc func signoutButton(_ sender: UIButton) {
        do {
            /**
             Removes all tokens from the cache for this application for the provided account
             
             - account:    The account to remove from the cache
             */
            
            let thisAccount = try self.getAccountByPolicy(withAccounts: applicationContext.allAccounts(), policy: kSignupOrSigninPolicy)
            
            if let accountToRemove = thisAccount {
                try applicationContext.remove(accountToRemove)
            } else {
                self.updateLoggingText(text: "There is no account to signing out!")
            }

            
            self.updateLoggingText(text: "Signed out")
            
        } catch  {
            self.updateLoggingText(text: "Received error signing out: \(error)")
        }
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
          authorizationButton()
        
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
    
    /**
     
     The way B2C knows what actions to perform for the user of the app is through the use of `Authority URL`.
     It is of the form `https://<instance/tfp/<tenant>/<policy>`, where `<instance>` is the
     directory host (e.g. https://login.microsoftonline.com), `<tenant>` is a
     identifier within the directory itself (e.g. a domain associated to the
     tenant, such as contoso.onmicrosoft.com), and `<policy>` is the policy you wish to
     use for the current user flow.
     */
    func getAuthority(forPolicy policy: String) throws -> MSALB2CAuthority {
        guard let authorityURL = URL(string: String(format: self.kEndpoint, self.kAuthorityHostName, self.kTenantName, policy)) else {
            throw NSError(domain: "SomeDomain",
                          code: 1,
                          userInfo: ["errorDescription": "Unable to create authority URL!"])
        }
        return try MSALB2CAuthority(url: authorityURL)
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


    // Add sign out button
    signOutButton = UIButton()
    signOutButton.translatesAutoresizingMaskIntoConstraints = false
    signOutButton.setTitle("Sign Out", for: .normal)
    signOutButton.setTitleColor(.blue, for: .normal)
    signOutButton.setTitleColor(.gray, for: .disabled)
    signOutButton.addTarget(self, action: #selector(signoutButton(_:)), for: .touchUpInside)
    self.view.addSubview(signOutButton)

    signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    signOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 380.0).isActive = true
    signOutButton.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
    signOutButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
          

    self.view.backgroundColor =  UIColor(red: 30.0/255.0 , green:  30.0/255.0 , blue :  30.0/255.0 , alpha: 1.0)
    }
}
