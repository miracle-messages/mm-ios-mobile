//
//  State.swift
//  MiracleMessages
//
//  Created by Eric Cormack on 6/25/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation

enum State: String {
    case Alabama
    case Alaska
    case AmericanSamoa = "American Samoa"
    case Arizona
    case Arkansas
    case California
    case Colorado
    case Connecticut
    case Delaware
    case DC = "District of Columbia"
    case Micronesia = "Federated States of Micronesia"
    case Florida
    case Georgia
    case Guam
    case Hawaii
    case Idaho
    case Illinois
    case Indiana
    case Iowa
    case Kansas
    case Kentucky
    case Louisiana
    case Maine
    case MashallIslands = "Marshall Islands"
    case Maryland
    case Massachusetts
    case Michigan
    case Minnesota
    case Mississippi
    case Missouri
    case Montana
    case Nebraska
    case Nevada
    case NewHampshire = "New Hampshire"
    case NewJersey = "New Jersey"
    case NewMexico = "New Mexico"
    case NewYork = "New York"
    case NorthCarolina = "North Carolina"
    case NorthDakota = "North Dakota"
    case NorthernMarianaIslands = "Nothern Mariana Islands"
    case Ohio
    case Oklahoma
    case Oregon
    case Palau
    case Pennsylvania
    case PuertoRico = "Puerto Rico"
    case RhodeIsland = "Rhode Island"
    case SouthCarolina = "South Carolina"
    case SouthDakota = "South Dakota"
    case Tennessee
    case Texas
    case Utah
    case Vermont
    case VirginIslands = "Virgin Islands"
    case Virginia
    case Washington
    case WestVirginia = "West Virginia"
    case Wisconsin
    case Wyoming
    
    var name: String { return rawValue }
    
    var code: String {
        switch self {
        case .Alabama: return "AL"
        case .Alaska: return "AK"
        case .AmericanSamoa: return "AS"
        case .Arizona: return "AZ"
        case .Arkansas: return "AR"
        case .California: return "CA"
        case .Colorado: return "CO"
        case .Connecticut: return "CT"
        case .Delaware: return "DE"
        case .DC: return "DC"
        case .Micronesia: return "FM"
        case .Florida: return "FL"
        case .Georgia: return "GA"
        case .Guam: return "GU"
        case .Hawaii: return "HI"
        case .Idaho: return "ID"
        case .Illinois: return "IL"
        case .Indiana: return "IN"
        case .Iowa: return "IA"
        case .Kansas: return "KS"
        case .Kentucky: return "KY"
        case .Louisiana: return "LA"
        case .Maine: return "ME"
        case .MashallIslands: return "MH"
        case .Maryland: return "MD"
        case .Massachusetts: return "MA"
        case .Michigan: return "MI"
        case .Minnesota: return "MN"
        case .Mississippi: return "MS"
        case .Missouri: return "MO"
        case .Montana: return "MT"
        case .Nebraska: return "NE"
        case .Nevada: return "NV"
        case .NewHampshire: return "NH"
        case .NewJersey: return "NJ"
        case .NewMexico: return "NM"
        case .NewYork: return "NY"
        case .NorthCarolina: return "NC"
        case .NorthDakota: return "ND"
        case .NorthernMarianaIslands: return "MP"
        case .Ohio: return "OH"
        case .Oklahoma: return "OK"
        case .Oregon: return "OR"
        case .Palau: return "PW"
        case .Pennsylvania: return "PA"
        case .PuertoRico: return "PR"
        case .RhodeIsland: return "RI"
        case .SouthCarolina: return "SC"
        case .SouthDakota: return "SD"
        case .Tennessee: return "TN"
        case .Texas: return "TX"
        case .Utah: return "UT"
        case .Vermont: return "VT"
        case .VirginIslands: return "VI"
        case .Virginia: return "VA"
        case .Washington: return "WA"
        case .WestVirginia: return "WV"
        case .Wisconsin: return "WI"
        case .Wyoming: return "WY"
        }
    }
    
    static var all: [State] = [.Alabama, .Alaska, .AmericanSamoa, .Arizona,
                               .Arkansas, .California, .Colorado, .Connecticut,
                               .Delaware, .DC, .Micronesia, .Florida, .Georgia,
                               .Guam, .Hawaii, .Idaho, .Illinois, .Indiana,
                               .Iowa, .Kansas, .Kentucky, .Louisiana, .Maine,
                               .MashallIslands, .Maryland, .Massachusetts,
                               .Michigan, .Minnesota, .Mississippi, .Missouri,
                               .Montana, .Nebraska, .Nevada, .NewHampshire,
                               .NewJersey, .NewMexico, .NewYork, .NorthCarolina,
                               .NorthDakota, .NorthernMarianaIslands, .Ohio,
                               .Oklahoma, .Oregon, .Palau, .Pennsylvania, 
                               .PuertoRico, .RhodeIsland, .SouthCarolina, 
                               .SouthDakota, .Tennessee, .Texas, .Utah, 
                               .Vermont, .VirginIslands, .Virginia, .Washington, 
                               .WestVirginia, .Wisconsin, .Wyoming]
}
