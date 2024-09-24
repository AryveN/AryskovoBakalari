//
//  TimetableLessons.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 27.02.2024.
//

import SwiftUI

struct LessonCell: View {
    let subjectAbbrev: String?
    let teacherAbbrev: String?
    let roomAbbrev: String?

    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            Text(teacherAbbrev ?? "")
                .font(.system(size: 12))
            Text(subjectAbbrev ?? "")
                .foregroundColor(Color.purple)
                .font(.system(size: 24))
                .fontWeight(.bold)
            Text(roomAbbrev ?? "")
                .font(.system(size: 16))
        }
    }
}

struct TimetableLessons: View {
    @Binding var presentSideMenu: Bool
    @State private var backToggle: Bool = false
    @State private var showingAlert = false
    @State private var redirectLogin = false
    @Environment(\.colorScheme) var colorScheme
    let days = try getDaysResponseFromUserDefaults()
    let subjects = getSubjectsResponseFromUserDefaults()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0..<5) { day in
                    DayView(day: day, days: days, geometry: geometry)
                }
            }
        }
    }
}

struct DayView: View {
    let day: Int
    let days: Days?
    let geometry: GeometryProxy

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<(getMaxHourID(from: days)-2)) { lesson in
                LessonView(day: day, lesson: lesson, days: days, geometry: geometry)
            }
        }
    }
}

struct LessonView: View {
    let day: Int
    let lesson: Int
    let days: Days?
    let geometry: GeometryProxy

    var body: some View {
        let subjects = getSubjectsResponseFromUserDefaults()
        let teachers = getTeachersResponseFromUserDefaults()
        let rooms = getRoomsResponseFromUserDefaults()
        
        let staticSubject = [Subject(Id: "0000", Abbrev: "", Name: "")]
        let staticTeacher = [Teacher(Id: "0000", Abbrev: "", Name: "")]
        let staticRoom = [Room(Id: "0000", Abbrev: "", Name: "")]
        
        if let atom = days?.Days[day].Atoms.first(where: { $0.HourId == lesson + 3 }) {
            if ((atom.Change) == nil) {
                LessonCell(subjectAbbrev: matchSubjectAbbrev(subjectId: atom.SubjectId ?? "0000", subjects: subjects?.Subjects ?? staticSubject), teacherAbbrev: matchTeacherAbbrev(teacherId: atom.TeacherId ?? "0000", teachers: teachers?.Teachers ?? staticTeacher), roomAbbrev: matchRoomAbbrev(roomId: atom.RoomId ?? "0000", rooms: rooms?.Rooms ?? staticRoom))
                    .frame(width: geometry.size.width / CGFloat((getMaxHourID(from: days)-2)), height: calculateHeight(geometry: geometry))
                    .foregroundColor(.white)
                    .background(Color(red: 0.30, green: 0.30, blue: 0.30))
                    .overlay(
                        Rectangle()
                            .inset(by: -0.5)
                            .stroke(Color(red: 0.25, green: 0.25, blue: 0.25), lineWidth: 1.5)
                    )
            } else {
                if(matchSubjectAbbrev(subjectId: atom.SubjectId ?? "0000", subjects: subjects?.Subjects ?? staticSubject) == nil) {
                    let varAbbrev = atom.Change?.TypeAbbrev
                    LessonCell(subjectAbbrev: atom.Change?.TypeAbbrev, teacherAbbrev: matchTeacherAbbrev(teacherId: atom.TeacherId ?? "0000", teachers: teachers?.Teachers ?? staticTeacher), roomAbbrev: matchRoomAbbrev(roomId: atom.RoomId ?? "0000", rooms: rooms?.Rooms ?? staticRoom))
                        .frame(width: geometry.size.width / CGFloat((getMaxHourID(from: days)-2)), height: calculateHeight(geometry: geometry))
                        .foregroundColor(.white)
                        .background(Color(red: 0.5, green: 0.1, blue: 0.2))
                        .overlay(
                            Rectangle()
                                .inset(by: -0.5)
                                .stroke(Color(red: 0.25, green: 0.25, blue: 0.25), lineWidth: 1.5)
                        )
                } else {
                    LessonCell(subjectAbbrev: matchSubjectAbbrev(subjectId: atom.SubjectId ?? "0000", subjects: subjects?.Subjects ?? staticSubject), teacherAbbrev: matchTeacherAbbrev(teacherId: atom.TeacherId ?? "0000", teachers: teachers?.Teachers ?? staticTeacher), roomAbbrev: matchRoomAbbrev(roomId: atom.RoomId ?? "0000", rooms: rooms?.Rooms ?? staticRoom))
                        .frame(width: geometry.size.width / CGFloat((getMaxHourID(from: days)-2)), height: calculateHeight(geometry: geometry))
                        .foregroundColor(.white)
                        .background(Color(red: 0.5, green: 0.1, blue: 0.2))
                        .overlay(
                            Rectangle()
                                .inset(by: -0.5)
                                .stroke(Color(red: 0.25, green: 0.25, blue: 0.25), lineWidth: 1.5)
                        )
                }
            }
        } else {
            EmptyLessonView(geometry: geometry, days: days)
        }
    }
}

struct EmptyLessonView: View {
    let geometry: GeometryProxy
    let days: Days?

    var body: some View {
        ZStack {
        }
        .frame(width: geometry.size.width / CGFloat((getMaxHourID(from: days)-2)), height: calculateHeight(geometry: geometry))
        .background(Color(red: 0.38, green: 0.38, blue: 0.38))
        .overlay(
            Rectangle()
                .inset(by: -0.5)
                .stroke(Color(red: 0.25, green: 0.25, blue: 0.25), lineWidth: 1.5)
        )
    }
}

