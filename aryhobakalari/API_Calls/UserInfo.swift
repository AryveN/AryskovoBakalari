//
//  FirstLogin.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 28.11.2023.
//

import Foundation
import SwiftyJSON
import SwiftUI

func userInfo(accessToken: String, completion: @escaping (Bool) -> Void) {
    let headers = [
        "Authorization": "Bearer " + accessToken,
        "cookie": "ASP.NET_SessionId=iy2fik0clpsz0jrwyswdqwvq",
        "Content-Type": "application/x-www-form-urlencoded"
    ]
    
    print("UserInfo API called")
    
    
    let request = NSMutableURLRequest(url: NSURL(string: "https://bakalari.uzlabina.cz/api/3/user")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        do {
            if let data = data {
                let bakalariData = try? JSON(data: data)
                if (error != nil) {
                    print(error as Any)
                    completion(false)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    if(httpResponse?.statusCode == 400) {
                        print(httpResponse?.statusCode as Any)
                        print(bakalariData?["error_description"].string as Any)
                        completion(false)
                    } else {
                        let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                        saveUserInfoToUserDefaults(userResponse)
                        completion(true)
                    }
                }
            }
        } catch {
            print("Error handling response: \(error)")
            completion(false)
        }
    })
    dataTask.resume()
}

struct ClassInfo: Codable {
    let id: String?
    let abbrev: String?
    let name: String?
    private enum CodingKeys: String, CodingKey {
            case abbrev = "Abbrev"
            case id = "Id"
            case name
    }
}

struct ModuleRights: Codable {
    let module: String
    let rights: [String]
}

struct EnabledModule: Codable {
    let module: String
    let rights: [String]
    
    private enum CodingKeys: String, CodingKey {
            case module = "Module"
            case rights = "Rights"
    }
}

enum ModuleType: String, Codable {
    case komens = "KomensModuleSettings"
    case homeworks = "HomeworksModuleSettings"
    case common = "CommonModuleSettings"
}

struct Semester: Codable {
    let semesterId: String
    let from: String
    let to: String
}

struct CommonModuleSettings: Codable {
    let actualSemester: Semester
    private enum CodingKeys: String, CodingKey {
            case actualSemester = "ActualSemester"
    }
}

struct SettingsModules: Codable {
    var komens: CommonModuleSettings
    var homeworks: CommonModuleSettings
    let common: CommonModuleSettings

    private enum CodingKeys: String, CodingKey {
            case komens = "Komens"
            case homeworks = "Homeworks"
            case common = "Common"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            do {
                komens = try container.decode(CommonModuleSettings.self, forKey: .komens)
                homeworks = try container.decode(CommonModuleSettings.self, forKey: .homeworks)
                common = try container.decode(CommonModuleSettings.self, forKey: .common)
            } catch {
                komens = CommonModuleSettings(actualSemester: Semester(semesterId: "", from: "", to: ""))
                homeworks = CommonModuleSettings(actualSemester: Semester(semesterId: "", from: "", to: ""))
                common = CommonModuleSettings(actualSemester: Semester(semesterId: "", from: "", to: ""))
            }
        }
}

struct UserResponse: Codable {
    let userUID: String
    let campaignCategoryCode: String
    let classInfo: ClassInfo
    let fullName: String
    let schoolOrganizationName: String
    let schoolType: String?
    let userType: String
    let userTypeText: String
    let studyYear: Int
    let enabledModules: [EnabledModule]
    let settingModules: SettingsModules
    let fullUserName: String
    let students: [ClassInfo]

    private enum CodingKeys: String, CodingKey {
        case userUID = "UserUID"
        case campaignCategoryCode = "CampaignCategoryCode"
        case classInfo = "Class"
        case fullName = "FullName"
        case schoolOrganizationName = "SchoolOrganizationName"
        case schoolType = "SchoolType"
        case userType = "UserType"
        case userTypeText = "UserTypeText"
        case studyYear = "StudyYear"
        case enabledModules = "EnabledModules"
        case settingModules = "SettingModules"
        case fullUserName = "FullUserName"
        case students = "Students"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userUID = try container.decode(String.self, forKey: .userUID)
        campaignCategoryCode = try container.decode(String.self, forKey: .campaignCategoryCode)
        classInfo = try container.decode(ClassInfo.self, forKey: .classInfo)
        fullName = try container.decode(String.self, forKey: .fullName)
        schoolOrganizationName = try container.decode(String.self, forKey: .schoolOrganizationName)
        schoolType = try container.decodeIfPresent(String.self, forKey: .schoolType)
        userType = try container.decode(String.self, forKey: .userType)
        userTypeText = try container.decode(String.self, forKey: .userTypeText)
        studyYear = try container.decode(Int.self, forKey: .studyYear)
        enabledModules = try container.decode([EnabledModule].self, forKey: .enabledModules)
        settingModules = try container.decode(SettingsModules.self, forKey: .settingModules)
        fullUserName = try container.decode(String.self, forKey: .fullUserName)
        students = try container.decode([ClassInfo].self, forKey: .students)
    }
}
func saveUserInfoToUserDefaults(_ userResponse: UserResponse) {
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    
    if let encoded = try? encoder.encode(userResponse) {
        defaults.set(encoded, forKey: "userResponse")
    }
}
