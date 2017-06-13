//
//  Case.swift
//  MiracleMessages
//
//  Created by Eric Cormack on 6/10/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation

class Case {
    //  Submission Basics
    var submissionDate: Date?
    var creator: VolunteerProfile?
    
    var hasDetectives: Bool = false
    
    //  Case Statuses
    var caseStatus: CaseStatus?
    var messageStatus: MessageStatus?
    var nextStep: NextStep?
    
    //  URLs
    var publicVideoURL: URL?
    var youTubeCoverURL: URL?
    var privateVideoURL: URL?
    var photoURL: URL?
    
    //  Source Info
    var source: Source?
    
    //  Sender Demographics
    var firstName: String?
    var middleName = ""
    var lastName: String?
    
    var age: Int?
    var isAgeApproximate: Bool = false
    var timeHomeless: (type: TimeType, value: Int)?
    
    var homeCity: String?
    var homeState: String?
    var homeCountry: String?    //  Country code
    
    //  Sender location
    var currentCity: String?
    var currentState: String?
    var currentCountry: String? //  Country code
    
    //  Static objects
    static let dateFormatter = defaultDateFormatter()
    
    private static func defaultDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YY"
        return formatter
    }
    
    //  Enums
    /**
     Status of this Case
     
     - Open: Active case to reunite sender with recipient
     - Closed: Sender and recipient have been reunited or other resolution
     - Cold: Case unresolved but without active leads
     */
    enum CaseStatus: String {
        case Open, Closed, Cold
    }
    
    /**
     Delivery status of sender's message
     
     - Undelivered: Message has not been delivered to recipient
     - Delivered: Message delivered to recipient
     - DidNotPost: Message has not yet been posted
     - Reunited: Sender and recipient have been reunited
     - Located: Recipient was located but refused message
     - Other: Message in other state, user should consult message notes
     */
    enum MessageStatus: String {
        case Undelivered
        case Delivered
        case DidNotPost = "Did not post"
        case Reunited
        case Located = "Located / No thanks"
        case Other = "Other / see notes"
    }
    
    /**
     The next step volunteers should follow in this case
     
     - FindLeads: Volunteers should work to find leads for locating recipient
     - LeadFollowUp: Volunteers should persue leads to completion
     - SenderFollowUp: Volunteers should follow-up with the sender
     - VolunteerFollowUp:
     - Reunite: A reunion between the sender and the recipient should be facilitated
     - Completed: Case has been resolved
     */
    enum NextStep: String {
        case FindLeads = "Find Leads / Dive in!"
        case LeadFollowUp = "Follow-up with leads"
        case SenderFollowUp = "Follow-up with MM sender"
        case VolunteerFollowUp = "Follow-up with Volunteer"
        case Reunite = "Facilitate Reunion"
        case Completed = "Done/Completed"
    }
    
    /**
     Timescales
     
     - weeks
     - months
     - years
     */
    enum TimeType: String { case weeks, months, years }
}
