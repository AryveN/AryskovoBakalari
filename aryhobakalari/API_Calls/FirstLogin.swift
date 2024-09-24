//
//  FirstLogin.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 13.09.2022.
//

import Foundation
import SwiftyJSON
import SwiftUI

func firstLogin(username: String, password: String, completion: @escaping (Bool) -> Void) {
    let headers = [
        "cookie": "ASP.NET_SessionId=iy2fik0clpsz0jrwyswdqwvq",
        "Content-Type": "application/x-www-form-urlencoded"
    ]
    
    var isLoading: Bool = true
    
    if (isLoading) {
        ProgressView("Přihlašování...")
    }
    
    print("FirstLogin API called")
    
    let localUsername = "&username=" + username
    let localPassword = "&password=" + password
    
    let postData = NSMutableData(data: "client_id=ANDR".data(using: String.Encoding.utf8)!)
    postData.append("&grant_type=password".data(using: String.Encoding.utf8)!)
    postData.append(localUsername.data(using: String.Encoding.utf8)!)
    postData.append(localPassword.data(using: String.Encoding.utf8)!)
    
    let request = NSMutableURLRequest(url: NSURL(string: "https://bakalari.uzlabina.cz/api/login")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData as Data
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        let bakalariData = JSON(data as Any)
        if (error != nil) {
            print(error as Any)
            isLoading = false
            completion(false)
        } else {
            let httpResponse = response as? HTTPURLResponse
            if(httpResponse?.statusCode == 400) {
                print(httpResponse?.statusCode as Any)
                print(bakalariData["error_description"].string as Any)
                isLoading = false
                completion(false)
            } else {
                isLoading = false
                
                let tokenResponse = TokenResponse(
                    expiresIn: bakalariData["expires_in"].intValue,
                    userId: bakalariData["bak:UserId"].stringValue,
                    apiVersion: bakalariData["bak:ApiVersion"].stringValue,
                    tokenType: bakalariData["token_type"].stringValue,
                    refreshToken: bakalariData["refresh_token"].stringValue,
                    scope: bakalariData["scope"].stringValue,
                    accessToken: bakalariData["access_token"].stringValue,
                    appVersion: bakalariData["bak:AppVersion"].stringValue
                )
                saveTokenResponseToUserDefaults(tokenResponse)
                completion(true)
                userInfo(accessToken: tokenResponse.accessToken) { success in
                    if success {
                        print("Getting UserInfo successful")
                    } else {
                        print("Getting UserInfo failed")
                    }
                }
            }
        }
    })
    dataTask.resume()
}

struct TokenResponse: Codable {
    let expiresIn: Int
    let userId: String
    let apiVersion: String
    let tokenType: String
    let refreshToken: String
    let scope: String
    let accessToken: String
    let appVersion: String

    private enum CodingKeys: String, CodingKey {
        case expiresIn = "expires_in"
        case userId = "bak:UserId"
        case apiVersion = "bak:ApiVersion"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case scope
        case accessToken = "access_token"
        case appVersion = "bak:AppVersion"
    }
}

func saveTokenResponseToUserDefaults(_ tokenResponse: TokenResponse) {
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    
    if let encoded = try? encoder.encode(tokenResponse) {
        defaults.set(encoded, forKey: "tokenResponse")
    }
}
