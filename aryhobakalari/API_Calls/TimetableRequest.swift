//
//  TimetableRequest.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 08.02.2024.
//

import Foundation
import SwiftyJSON

public func timetableRequest(date: Date ,accessToken: String, completion: @escaping (Bool) -> Void) {
    let headers = [
        "Authorization": "Bearer " + accessToken,
        "cookie": "ASP.NET_SessionId=iy2fik0clpsz0jrwyswdqwvq",
        "Content-Type": "application/x-www-form-urlencoded"
    ]
    
    print("Timetable API called")
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd" // Specify your desired format here
    let currentDate = date
    let formattedDate = dateFormatter.string(from: currentDate)
    
    let request = NSMutableURLRequest(url: NSURL(string: "https://bakalari.uzlabina.cz/api/3/timetable/actual?date=" + formattedDate)! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    print("\(request)")
    
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
                        let hoursResponse = try JSONDecoder().decode(Hours.self, from: data)
                        let daysResponse = try JSONDecoder().decode(Days.self, from: data)
                        let subjectsResponse = try JSONDecoder().decode(Subjects.self, from: data)
                        let teachersResponse = try JSONDecoder().decode(Teachers.self, from: data)
                        let roomsResponse = try JSONDecoder().decode(Rooms.self, from: data)
                        /*let changeResponse = try JSONDecoder().decode(Change.self, from: data)
                        let classResponse = try JSONDecoder().decode(Classen.self, from: data)
                        let groupResponse = try JSONDecoder().decode(Groupen.self, from: data)
                        */
                        saveHoursInfoToTimetableDefaults(hoursResponse)
                        saveDaysInfoToTimetableDefaults(daysResponse)
                        saveSubjectsInfoToTimetableDefaults(subjectsResponse)
                        saveTeachersInfoToTimetableDefaults(teachersResponse)
                        saveRoomsInfoToTimetableDefaults(roomsResponse)
                        /*saveAtomInfoToTimetableDefaults(atomResponse)
                        saveChangeInfoToTimetableDefaults(changeResponse)
                        saveClassInfoToTimetableDefaults(classResponse)
                        saveGroupInfoToTimetableDefaults(groupResponse)
                        */

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


// Define structs for each data type
struct Hours: Codable {
    let Hours: [Hour]
}
struct Hour: Codable {
    let Id: Int?
    let Caption: String?
    let BeginTime: String?
    let EndTime: String?
}
struct Days: Codable {
    let Days: [Day]
}
struct Day: Codable {
    let Atoms: [Atom]
    let DayOfWeek: Int
    let Date: String
    let DayDescription: String
    let DayType: String
}
struct Atoms: Codable {
    let Atoms: [Atom]
}
struct Atom: Codable {
    let HourId: Int
    let GroupIds: [String]?
    let SubjectId: String?
    let TeacherId: String?
    let RoomId: String?
    let CycleIds: [String]?
    let Change: Change?
    let HomeworkIds: [String]?
    let Theme: String?
    let Assistants: [String]?
}
struct Change: Codable {
    let ChangeSubject: String?
    let Day: String
    let Hours: String
    let ChangeType: String
    let Description: String
    let Time: String
    let TypeAbbrev: String?
    let TypeName: String?
}
struct Classen: Codable {
    let id: String
    let abbrev: String
    let name: String
}
struct Groupen: Codable {
    let classId: String
    let id: String
    let abbrev: String
    let name: String
}
struct Subjects: Codable {
    let Subjects: [Subject]
}
struct Subject: Codable {
    let Id: String
    let Abbrev: String
    let Name: String
}
struct Teachers: Codable {
    let Teachers: [Teacher]
}
struct Teacher: Codable {
    let Id: String
    let Abbrev: String
    let Name: String
}
struct Rooms: Codable {
    let Rooms: [Room]
}
struct Room: Codable {
    let Id: String
    let Abbrev: String
    let Name: String
}
struct Cycle: Codable {
    let id: String
    let abbrev: String
    let name: String
}

func saveHoursInfoToTimetableDefaults(_ hoursResponse: Hours) {
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    
    if let encoded = try? encoder.encode(hoursResponse) {
        defaults.set(encoded, forKey: "hoursResponse")
    }
}
func saveDaysInfoToTimetableDefaults(_ daysResponse: Days) {
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    
    if let encoded = try? encoder.encode(daysResponse) {
        defaults.set(encoded, forKey: "daysResponse")
    }
}
func saveAtomsInfoToTimetableDefaults(_ atomsResponse: Atoms) {
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    
    if let encoded = try? encoder.encode(atomsResponse) {
        defaults.set(encoded, forKey: "atomsResponse")
    }
}
func saveChangeInfoToTimetableDefaults(_ changeResponse: Change) {
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    
    if let encoded = try? encoder.encode(changeResponse) {
        defaults.set(encoded, forKey: "changeResponse")
    }
}
func saveClassInfoToTimetableDefaults(_ classResponse: Classen) {
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    
    if let encoded = try? encoder.encode(classResponse) {
        defaults.set(encoded, forKey: "classResponse")
    }
}
func saveGroupInfoToTimetableDefaults(_ groupResponse: Groupen) {
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    
    if let encoded = try? encoder.encode(groupResponse) {
        defaults.set(encoded, forKey: "groupResponse")
    }
}
func saveSubjectsInfoToTimetableDefaults(_ subjectsResponse: Subjects) {
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    
    if let encoded = try? encoder.encode(subjectsResponse) {
        defaults.set(encoded, forKey: "subjectsResponse")
    }
}
func saveTeachersInfoToTimetableDefaults(_ teachersResponse: Teachers) {
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    
    if let encoded = try? encoder.encode(teachersResponse) {
        defaults.set(encoded, forKey: "teachersResponse")
    }
}
func saveRoomsInfoToTimetableDefaults(_ roomsResponse: Rooms) {
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    
    if let encoded = try? encoder.encode(roomsResponse) {
        defaults.set(encoded, forKey: "roomsResponse")
    }
}
