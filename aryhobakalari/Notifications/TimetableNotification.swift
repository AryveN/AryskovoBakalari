import UIKit
import BackgroundTasks
import UserNotifications
import os

class NotificationScheduler {
    
    let logger = Logger()
    
    public func scheduleNotificationsBackgroundTask() {
        let backgroundAppRefreshTaskSchedulerIdentifier = "com.aryven.uwuzvrh_notifications"
        //let backgroundProcessingTaskSchedulerIdentifier = "com.example.fooBackgroundProcessingIdentifier"
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundAppRefreshTaskSchedulerIdentifier, using: nil) { (task) in
            print("BackgroundAppRefreshTaskScheduler is executed NOW!")
            print("Background time remaining: \(UIApplication.shared.backgroundTimeRemaining)s")
            task.expirationHandler = {
                task.setTaskCompleted(success: false)
            }
            
            // Do some data fetching and call setTaskCompleted(success:) asap!
            let isFetchingSuccess = true
            task.setTaskCompleted(success: isFetchingSuccess)
        }
    }
    
    func findNextLesson(from hours: [Hour], currentId: Int) -> Hour? {
        for hour in hours {
            //logger.debug("\(hour.Id) ~ \(currentId)")
            //print("\(hour.Id) | \(currentId)")
            if hour.Id ?? 0000 > currentId {
                return hour
            }
        }
        return nil // No next lesson found in the provided list
    }
    
    func findNextClass(from day: Day, nextLesson: Hour) -> Atom? {
        for atom in day.Atoms {
            if atom.HourId == nextLesson.Id {
                //logger.debug("\(atom.HourId) ~ \(nextLesson.Id)")
                return atom
            }
        }
        return nil
    }
    
    func isTimeInRange(startTime: String, endTime: String, currentTime: String) -> Bool {
        //print(currentTime >= startTime && currentTime < endTime)
        let dateFormatter = DateFormatter()
        let targetTimeZone = TimeZone(identifier: "Europe/Prague")!
        dateFormatter.timeZone = targetTimeZone
        dateFormatter.dateFormat = "HH:mm"
        
        guard let currentTimeDate = dateFormatter.date(from: currentTime) else {
            print("Error: Invalid current time format")
            return false
        }
        guard let startTimeDate = dateFormatter.date(from: startTime) else {
            print("Error: Invalid start time format")
            return false
        }
        guard let endTimeDate = dateFormatter.date(from: endTime) else {
            print("Error: Invalid end time format")
            return false
        }
        let oneHour: TimeInterval = 3600
        let currentTimeNevim = currentTimeDate - oneHour
        
//        logger.warning("\(currentTimeDate) | \(startTimeDate) - \(endTimeDate) | \(currentTimeDate >= startTimeDate) | \(currentTimeDate < endTimeDate)")
//        logger.info("\(currentTime) | \(startTime) - \(endTime) | \(currentTime >= startTime) | \(currentTime < endTime)")
//        logger.debug("\(currentTimeNevim >= startTimeDate) | \(currentTimeNevim < endTimeDate)")
        return currentTimeNevim >= startTimeDate && currentTimeNevim < endTimeDate
    }
    
    func scheduleNotifications() {
        timetableRequest(date: Date(), accessToken: getTokenResponseFromUserDefaults()?.accessToken ?? "") { [self] success in
            if success {
                logger.info("Getting TimeTable for notification successful")
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                    if granted {
                        print("Notification permissions granted!")
                        scheduleNotificationsFromTimetable()
                        // Schedule notifications here if permission is granted
                    } else {
                        print("Notification permissions denied: \(error?.localizedDescription ?? "Unknown error")")
                        // Handle user declined notification permission (optional)
                    }
                }
            } else {
                logger.info("Getting TimeTable for notification failed")
            }
        }
    }
    
    private func scheduleNotificationsFromTimetable() {
        guard let hours = getHoursResponseFromUserDefaults() else {
            print("No hours available")
            return
        }
        
        guard let days = getDaysResponseFromUserDefaults()?.Days else {
            print("No days available")
            return
        }
        
        let currentDate = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm" // Assuming times are in HH:mm format
        let currentTime = formatter.string(from: currentDate)
        
        let dateFormatterHours = DateFormatter()
        dateFormatterHours.dateFormat = "yyyy-MM-dd HH:mm"
        
        for day in days {
            
            var classCount = 0
            var currentHourId = 0
            
            let formattedDate: String
            
            let dayDateFormatter = DateFormatter()
            dayDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dayDateFormatter.date(from: day.Date)
            
            let formattedDateFormatter = DateFormatter()
            formattedDateFormatter.dateFormat = "yyyy-MM-dd"
            formattedDate = formattedDateFormatter.string(from: date!)

            
            
//            print(yesterday)
//            print(formattedDate)
//            print("\(currentDate) \n")
            
            /*if (yesterday < formattedDateFormatter.date(from: formattedDate) ?? Date() && formattedDateFormatter.date(from: formattedDate) ?? Date() <= currentDate) {*/
            for atom in day.Atoms {
                //                    for hour in hours.Hours {
                //                        //print("\(hour.BeginTime) - \(hour.EndTime) | \(currentTime)")
                //                        if isTimeInRange(startTime: hour.BeginTime, endTime: hour.EndTime, currentTime: currentTime) {
                //                            //logger.info("Hodina: \(hour.Id)")
                //                            currentHourId = hour.Id + classCount
                //                            break
                //                        }
                //                    }
                //print(day.Atoms)
                currentHourId = 2 + classCount
                if let nextLesson = findNextLesson(from: hours.Hours, currentId: currentHourId ?? 99) {
                    
                    let currentHour = "\(currentDate) \(currentTime)"
                    let nextLessonTime = "\(formattedDate) \(nextLesson.BeginTime ?? "0:00")"
                    
                    //if(nextLessonTime > currentHour) {
                        //Calculate the notification time (10 minutes before the lesson)
                    guard let notificationTime = Calendar.current.date(byAdding: .minute, value: -10, to: (dateFormatterHours.date(from: nextLessonTime)!)) else {
                            break
                        }
                        // Prepare notification content
                        let subjects = getSubjectsResponseFromUserDefaults()?.Subjects
                        let staticSubject = [Subject(Id: "0000", Abbrev: "", Name: "")]
                        
                        let rooms = getRoomsResponseFromUserDefaults()?.Rooms
                        let staticRoom = [Room(Id: "0000", Abbrev: "", Name: "")]
                        
                        let teachers = getTeachersResponseFromUserDefaults()?.Teachers
                        let staticTeacher = [Teacher(Id: "0000", Abbrev: "", Name: "")]
                        
                        if let nextClass = findNextClass(from: day, nextLesson: nextLesson) {
                            
                            let content = UNMutableNotificationContent()
                            content.title = "Next Lesson"
                            content.body = "\(matchSubjectName(subjectId: nextClass.SubjectId ?? "0000", subjects: subjects ?? staticSubject) ?? "xy") in \(matchRoomAbbrev(roomId: nextClass.RoomId ?? "0000", rooms: rooms ?? staticRoom) ?? "xy") with \(matchTeacherName(teacherId: nextClass.TeacherId ?? "0000", teachers: teachers ?? staticTeacher) ?? "xy")"
                            content.sound = UNNotificationSound.default
                            
                            // Create the notification trigger
                            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationTime), repeats: false)
                            
                            // Create the notification request
                            let request = UNNotificationRequest(identifier: "lessonNotification_\(formattedDate)_\(currentHourId ?? 9999)_\(notificationTime)", content: content, trigger: trigger)
                            
                            // Schedule the notification
                            UNUserNotificationCenter.current().add(request) { error in
                                if let error = error {
                                    print("Error scheduling notification: \(error)")
                                } else {
                                    print("Notification scheduled successfully at \(notificationTime)")
                                }
                            }
                            classCount = classCount + 1
                        }
                    //}
                    //                    } else {
                    //                        print("No upcoming lessons found")
                    //                    }
                }
            }
        }
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            for request in requests {
                self.logger.info("Pending Notification - ID: \(request.identifier), Content: \(request.content.body)")
            }
        }
    }
}
