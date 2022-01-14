//
//  MSALVars.swift
//  BTC Watch
//
//  Created by Jas on 03/01/2022.
//  Copyright © 2022 Jastech Ltd. All rights reserved.
//

import Foundation
import MSAL


struct MyVariables {
  static var token : String?
  static var kTenantName = "b2cprod.onmicrosoft.com" // Your tenant name
  static var kAuthorityHostName = "b2cprod.b2clogin.com" // Your authority host name
  static var kClientID = "662225f9-fc44-42b9-b185-a2147720e3f1" // Your client ID from the portal when you created your application
  static var kRedirectUri = "msauth.com.microsoft.identitysample.MSALiOS://auth" // Your application's redirect URI
  static var kSignupOrSigninPolicy = "B2C_1_signin" // Your signup and sign-in policy you created in the portal
  static var kEditProfilePolicy = "b2c_1_edit_profile" // Your edit policy you created in the portal
  static var kResetPasswordPolicy = "b2c_1_reset" // Your reset password policy you created in the portal
  let kGraphURI = "https://fabrikamb2chello.azurewebsites.net/hello" // This is your backend API that you've configured to accept your app's tokens
  static var kScopes: [String] = ["https://b2cprod.onmicrosoft.com/test/read"] // This is a scope that you've configured your backend API to look for.
    
    // DO NOT CHANGE - This is the format of OIDC Token and Authorization endpoints for Azure AD B2C.
  static var kEndpoint = "https://%@/tfp/%@/%@"
    
  static var applicationContext: MSALPublicClientApplication!
    public var accessToken: String?
  static var webViewParamaters : MSALWebviewParameters?
  static var userObjectId : String?
}

class MyMSAL{
  



func SetupMSAL() {
  do {
  let siginPolicyAuthority = try getAuthority(forPolicy: MyVariables.kSignupOrSigninPolicy)
  let editProfileAuthority = try getAuthority(forPolicy: MyVariables.kEditProfilePolicy)

  // Provide configuration for MSALPublicClientApplication
  // MSAL will use default redirect uri when you provide nil
    let pcaConfig = MSALPublicClientApplicationConfig(clientId: MyVariables.kClientID, redirectUri: MyVariables.kRedirectUri, authority: siginPolicyAuthority)
  pcaConfig.knownAuthorities = [siginPolicyAuthority, editProfileAuthority]
  
    MyVariables.applicationContext = try MSALPublicClientApplication(configuration: pcaConfig)

  } catch {
      //MyVariables.updateLoggingText(text: "Unable to create application \(error)")
    print("fail1")
  }
}


  
  func signOut() {
      do {
          /**
           Removes all tokens from the cache for this application for the provided account
           
           - account:    The account to remove from the cache
           */
          
        let thisAccount = try getAccountByPolicy(withAccounts: MyVariables.applicationContext.allAccounts(), policy: MyVariables.kSignupOrSigninPolicy)
          
          if let accountToRemove = thisAccount {
            try MyVariables.applicationContext.remove(accountToRemove)
            MyVariables.token = nil
            print("fremoved account")
          } else {
            print("failed to remove account")
              //self.updateLoggingText(text: "There is no account to signing out!")
          }

          
          //self.updateLoggingText(text: "Signed out")
          
      } catch  {
          //self.updateLoggingText(text: "Received error signing out: \(error)")
      }
  }

/*  func interactiveLogin() {
        do {
            let authority = try getAuthority(forPolicy: MyVariables.kSignupOrSigninPolicy)
          let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
          let homeView  = storyBoard.instantiateViewController(withIdentifier: "signInPage") as! ViewController
          initWebViewParams(vc:homeView)
            
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
            //self.showSecondViewController()
            
            }
        } catch {
          print("fail3")
            print(error)
        }
    }*/
  
  
  func refreshToken(){
      
      do {
          
          let authority = try getAuthority(forPolicy: MyVariables.kSignupOrSigninPolicy)

        guard let thisAccount = try getAccountByPolicy(withAccounts: MyVariables.applicationContext.allAccounts(), policy: MyVariables.kSignupOrSigninPolicy) else {
              //self.updateLoggingText(text: "There is no account available!")
          
          return
          }
          
        let parameters = MSALSilentTokenParameters(scopes: MyVariables.kScopes, account:thisAccount)
        parameters.authority = authority
        
        
        MyVariables.applicationContext.acquireTokenSilent(with: parameters) { (result, error) in
          if let error = error {
              let nsError = error as NSError
              
              // interactionRequired means we need to ask the user to sign-in. This usually happens
              // when the user's Refresh Token is expired or if the user has changed their password
              // among other possible reasons.
              
              if (nsError.domain == MSALErrorDomain) {
                  if (nsError.code == MSALError.interactionRequired.rawValue) {
                      
                      // Notice we supply the account here. This ensures we acquire token for the same account
                      // as we originally authenticated.
                      
                      let parameters = MSALInteractiveTokenParameters(scopes: MyVariables.kScopes, webviewParameters: MyVariables.webViewParamaters!)
                      parameters.account = thisAccount
                      MyVariables.applicationContext.acquireToken(with: parameters) { (result, error) in
                          guard let result = result else {
                              //self.updateLoggingText(text: "Could not acquire new token: \(error ?? "No error informarion" as! Error)")
                            
                            return
                          }
                          
                        MyVariables.token = result.accessToken
                          //self.updateLoggingText(text: "Access token is \(self.accessToken ?? "empty")")
                      }
                      return
                  }
              }
            print("Could not acquire token: \(error)")
              return
          }
          
            guard let result = result
            else {
                print("Could not acquire token: No result returned")
                return
              }
          MyVariables.token = result.accessToken
          MyVariables.userObjectId = result.uniqueId
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
              //self.updateLoggingText(text: "Refreshing token silently")
            print("Refreshed access token is \(MyVariables.token ?? "empty")")
            return
          }
      } catch {
        print("Unable to construct parameters before calling acquire token \(error)")
      }
    //MyVariables.token = result.accessToken
    return
  }
  
}


/**/

func getAuthority(forPolicy policy: String) throws -> MSALB2CAuthority {
    guard let authorityURL = URL(string: String(format: MyVariables.kEndpoint, MyVariables.kAuthorityHostName, MyVariables.kTenantName, policy)) else {
        throw NSError(domain: "SomeDomain",
                      code: 1,
                      userInfo: ["errorDescription": "Unable to create authority URL!"])
    }
    return try MSALB2CAuthority(url: authorityURL)
}

func initWebViewParams(vc: UIViewController) {
  MyVariables.webViewParamaters = MSALWebviewParameters(authPresentationViewController: vc)
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
  
