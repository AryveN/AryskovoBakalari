//
//  MatchTimetable.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 27.02.2024.
//

import Foundation

func matchSubjectName(subjectId: String, subjects: [Subject]) -> String? {
    for subject in subjects {
        if subject.Id == subjectId {
            return subject.Name
        }
    }
    return nil
}
func matchSubjectAbbrev(subjectId: String, subjects: [Subject]) -> String? {
    for subject in subjects {
        if subject.Id == subjectId {
            return subject.Abbrev
        }
    }
    return nil
}
func matchTeacherName(teacherId: String, teachers: [Teacher]) -> String? {
    for teacher in teachers {
        if teacher.Id == teacherId {
            return teacher.Name
        }
    }
    return nil
}
func matchTeacherAbbrev(teacherId: String, teachers: [Teacher]) -> String? {
    for teacher in teachers {
        if teacher.Id == teacherId {
            return teacher.Abbrev
        }
    }
    return nil
}
func matchRoomAbbrev(roomId: String, rooms: [Room]) -> String? {
    for room in rooms {
        if room.Id == roomId {
            return room.Abbrev
        }
    }
    return nil
}
