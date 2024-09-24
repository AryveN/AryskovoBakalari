//
//  GetUserDefaults.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 28.11.2023.
//

import Foundation

func getTokenResponseFromUserDefaults() -> TokenResponse? {
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    
    if let savedTokenResponse = defaults.object(forKey: "tokenResponse") as? Data {
        if let tokenResponse = try? decoder.decode(TokenResponse.self, from: savedTokenResponse) {
            return tokenResponse
        }
    }
    
    return nil
}
func getUserResponseFromUserDefaults() -> UserResponse? {
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    
    if let savedUserResponse = defaults.object(forKey: "userResponse") as? Data {
        if let userResponse = try? decoder.decode(UserResponse.self, from: savedUserResponse) {
            return userResponse
        }
    }
    
    return nil
}
func getHoursResponseFromUserDefaults() -> Hours? {
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    
    if let savedHoursResponse = defaults.object(forKey: "hoursResponse") as? Data {
        if let hoursResponse = try? decoder.decode(Hours.self, from: savedHoursResponse) {
            return hoursResponse
        }
    }
    
    return nil
}
func getDaysResponseFromUserDefaults() -> Days? {
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    
    if let savedDaysResponse = defaults.object(forKey: "daysResponse") as? Data {
        if let daysResponse = try? decoder.decode(Days.self, from: savedDaysResponse) {
            return daysResponse
        }
    }
    
    return nil
}
func getSubjectsResponseFromUserDefaults() -> Subjects? {
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    
    if let savedSubjectsResponse = defaults.object(forKey: "subjectsResponse") as? Data {
        if let subjectsResponse = try? decoder.decode(Subjects.self, from: savedSubjectsResponse) {
            return subjectsResponse
        }
    }
    
    return nil
}
func getTeachersResponseFromUserDefaults() -> Teachers? {
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    
    if let savedTeachersResponse = defaults.object(forKey: "teachersResponse") as? Data {
        if let teachersResponse = try? decoder.decode(Teachers.self, from: savedTeachersResponse) {
            return teachersResponse
        }
    }
    
    return nil
}
func getRoomsResponseFromUserDefaults() -> Rooms? {
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    
    if let savedRoomsResponse = defaults.object(forKey: "roomsResponse") as? Data {
        if let roomsResponse = try? decoder.decode(Rooms.self, from: savedRoomsResponse) {
            return roomsResponse
        }
    }
    
    return nil
}
