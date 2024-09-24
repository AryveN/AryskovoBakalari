//
//  SideMenuEnum.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 28.11.2023.
//

import Foundation

enum SideMenuRowType: Int, CaseIterable{
    case home = 0
    case timetable
    case grades
    case absence
    case komens
    case events
    case midterm
    case substitution
    case subjects
    case tuition
    case infochannel
    case polls
    case logout
    
    var title: String{
        switch self {
        case .home:
            return "Úvod"
        case .timetable:
            return "Rozvrh"
        case .grades:
            return "Známky"
        case .absence:
            return "Absence"
        case .komens:
            return "Komens"
        case .events:
            return "Plán Akcí"
        case .midterm:
            return "Pololetí"
        case .substitution:
            return "Suplování"
        case .subjects:
            return "Předměty"
        case .tuition:
            return "Výuka"
        case .infochannel:
            return "Infokanál"
        case .polls:
            return "Ankety"
        case .logout:
            return "Odhlásit se"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "house.fill"
        case .timetable:
            return "tablecells"
        case .grades:
            return "1.square"
        case .absence:
            return "person.fill.badge.minus"
        case .komens:
            return "envelope"
        case .events:
            return "calendar"
        case .midterm:
            return "rectangle.lefthalf.fill"
        case .substitution:
            return "person.crop.circle.badge.exclamationmark"
        case .subjects:
            return "book"
        case .tuition:
            return "graduationcap"
        case .infochannel:
            return "info.circle"
        case .polls:
            return "checkmark.square"
        case .logout:
            return "rectangle.portrait.and.arrow.right"
        }
    }
}
