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
  
}

class MyMSAL{
  



func SetupMSAL(vc: UIViewController) {
  do {
  let siginPolicyAuthority = try getAuthority(forPolicy: MyVariables.kSignupOrSigninPolicy)
  let editProfileAuthority = try getAuthority(forPolicy: MyVariables.kEditProfilePolicy)

  // Provide configuration for MSALPublicClientApplication
  // MSAL will use default redirect uri when you provide nil
    let pcaConfig = MSALPublicClientApplicationConfig(clientId: MyVariables.kClientID, redirectUri: MyVariables.kRedirectUri, authority: siginPolicyAuthority)
  pcaConfig.knownAuthorities = [siginPolicyAuthority, editProfileAuthority]
  
    MyVariables.applicationContext = try MSALPublicClientApplication(configuration: pcaConfig)
    initWebViewParams(vc: vc)
    
  } catch {
      //MyVariables.updateLoggingText(text: "Unable to create application \(error)")
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
                    return
                }
                
                //MyVariables.accessToken = result.accessToken
                MyVariables.token = result.accessToken
                //self.updateLoggingText(text: "Access token is \(self.accessToken ?? "Empty")")
                /*self.signOutButton.isEnabled = true
                self.callGraphButton.isEnabled = true
                self.editProfileButton.isEnabled = true
                self.refreshTokenButton.isEnabled = true*/
              
                //self.showSecondViewController()
            }
        } catch {
            //self.updateLoggingText(text: "Unable to create authority \(error)")
        }
    }
  
  
  
}
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
}
