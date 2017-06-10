//
//  Case.swift
//  MiracleMessages
//
//  Created by Eric Cormack on 6/10/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation

class Case {
    //  Submission Info
    var submissionDate: Date?
    var creator: VolunteerProfile?
    var isCaseOpen = true
    var isMessageDelivered = false
    var nextStep: String?
    var publicVideoURL: URL?
    var youTubeCoverURL: URL?
    var privateVideoURL: URL?
    var photoURL: URL?
    var source = (platform: "iOS", version: Bundle.main.value(forKey: "CFBundleShortVersionString"))
    
    //  Sender Info
    var firstName: String?
    var middleName = ""
    var lastName: String?
    
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
        case DidNotPost
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
}
