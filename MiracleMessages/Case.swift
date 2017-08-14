//
//  Case.swift
//  MiracleMessages
//
//  Created by Eric Cormack on 6/10/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation
import Firebase

class Case {
    //  Current case
    static var current = Case()
    
    /**
     Replaces current case with a fresh and empty case
     
     Returns: The new current case
     */
    static func startNewCase() -> Case {
        current = Case()
        return current
    }
    
    //  Submission Basics
    var submissionDate: Date?
    var volunteer: VolunteerProfile?
    var key: String?
    
    var hasDetectives: Bool = false
    
    //  Case Statuses
    var caseStatus: CaseStatus = .Open
    var messageStatus: MessageStatus = .Undelivered
    var nextStep: NextStep = .FindLeads
    
    //  URLs
    var publicVideoURL: URL?
    var youtubeCoverURL: URL?
    var privateVideoURL: URL?
    var photoURL: URL?
    var signatureURL: URL?

    //  Source Info
    var source = Source.current
    
    //  Sender Demographics
    var firstName: String?
    var middleName: String?
    var lastName: String?
    
    var age: Int?
    var isAgeApproximate = false
    var dateOfBirth: Date?
    var isDOBApproximate = false
    var timeHomeless: (type: TimeType, value: Int)?
    
    var homeCity: String?
    var homeState: String?
    var homeCountry: Country?
    
    //  Sender location
    var currentCity: String?
    var currentState: String?
    var currentCountry: Country?
    var locationGPS: String = ""
    
    //  Partner organization
    var partner: String?
    
    //  Loved ones
    var lovedOnes: Set<LovedOne> = []
    
    //  chapter?
    var chapterID: String?
    var detectives: [String] = []
    
    //  Notes
    var notes: String = ""

    func generateKey(withRef firebase: DatabaseReference) {
        key = firebase.child("/cases/").childByAutoId().key
    }
    
    //  Writing to the database
    /**
     Writes the case to FireBase in three steps, first to get case ID,
     then to write public info and finally to write private info
     
     - Parameter to: Root Firebase Database Reference
     - Parameter handler: Completion handler where the input to the closure is
     a boolean whose value is whether or not the submission was successful.
     */
    func submitCase(to firebase: DatabaseReference, handler: @escaping(Bool) -> Void = { _ in }) {
        if submissionDate == nil { submissionDate = Date() }
        
        guard let submissionSinceEpoch = submissionDate?.timeIntervalSince1970
            else { return }
//        guard let publicVideoAddress = publicVideoURL?.absoluteString
//            else { return }
//        guard let privateVideoAddress = privateVideoURL?.absoluteString
//            else { return }
//        guard let youtubeCoverAddress = youtubeCoverURL?.absoluteString
//            else { return }
//        guard let photoAddress = photoURL?.absoluteString
//            else { return }
        guard let givenName = firstName, let midName = middleName, let surname = lastName
            else { return }
        guard let thisCity = currentCity, let thisState = currentState, let thisCountry = currentCountry
            else { return }
        guard let oldCity = homeCity, let oldState = homeState, let oldCountry = homeCountry
            else { return }
        guard let dob = dateOfBirth, let age = Calendar.current.dateComponents([.year], from: dob, to: submissionDate!).year
            else { return }
        guard let timeWithoutHome = timeHomeless else { return }
        
        let caseReference: DatabaseReference
        
        if key == nil {
            caseReference = firebase.child("/cases/").childByAutoId()
            key = caseReference.key
        } else {
            caseReference = firebase.child("/cases/\(key!)")
        }
        
        let privateCaseReference = firebase.child("/casesPrivate/\(key!)")
        
        var publicPayload: [String: Any] = [
            "submitted": Int(submissionSinceEpoch),
            "caseStatus": caseStatus.rawValue,
            "messageStatus": messageStatus.rawValue,
            "nextStep": nextStep.rawValue,
//            "pubVideo": publicVideoAddress,
//            "youtubeCover": youtubeCoverAddress,
//            "privVideo": privateVideoAddress,
            "source": source.dictionary,
//            "photo": photoAddress,
            "firstName": givenName,
            "middleName": midName,
            "lastName": surname,
            "currentCity": thisCity,
            "currentState": thisState,
            "currentCountry": thisCountry.code,
            "homeCity": oldCity,
            "homeState": oldState,
            "homeCountry": oldCountry.code,
            "age": age,
            "ageApproximate": isDOBApproximate,
            "detectives": detectives.count > 0,
            "timeHomeless": ["type": timeWithoutHome.type.rawValue, "value": timeWithoutHome.value] as [String: Any]
        ]
        
        if let currentUser = Auth.auth().currentUser {
            publicPayload["createdBy"] = ["uid": currentUser.uid]
        }
        
        if let partner = partner {
            publicPayload["partner"] = ["partnerName": partner]
        }
        
        let privatePayload: [String: Any] = [
            "dob": DateFormatter.default.string(from: dob),
            "dobApproximate": isDOBApproximate,
            "notes": notes,
            "signatureUrl": signatureURL?.absoluteString ?? "none"
        ]
        
        //  Write case data
        caseReference.setValue(publicPayload) { error, _ in
            //  If unsuccessful, print and return
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            //  If successful, write private case data
            privateCaseReference.setValue(privatePayload) { error, _ in
                //  If private write unsuccessful, remove case data and return
                guard error == nil else {
                    print(error!.localizedDescription)
                    caseReference.removeValue()
                    return
                }
                
                print("Case successfully written")
                
                //  If successful, write loved ones
                for lovedOne in self.lovedOnes {
                    //  Get reference to loved one
                    let lovedOneRef = caseReference.child("/lovedOnes/").childByAutoId()
                    lovedOne.id = lovedOneRef.key
                    
                    //  Try to write
                    lovedOneRef.setValue(lovedOne.publicInfo) { error, _ in
                        //  If unsuccessful return
                        guard error == nil else {
                            print(error!.localizedDescription)
                            return
                        }
                        
                        //  If successful, write private info
                        privateCaseReference.child("/lovedOnes/\(lovedOne.id!)").setValue(lovedOne.privateInfo) { error, _ in
                            //  If unsuccessful, remove public loved one info
                            guard error == nil else {
                                print(error!)
                                lovedOneRef.removeValue()
                                return
                            }
                            
                            print("Loved one successfully written")
                        }
                    }
                }
            }
        }
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
    enum TimeType: String {
        case weeks, months, years
        
        static let all: [TimeType] = [.weeks, .months, .years]
    }
}

extension Case: Reviewable {
    //  Data for review cell
    /**
     Assembles the parts of the name into a single string
     */
    var fullName: String {
        var this = ""
        if let bit = firstName, bit != "" { this += bit + " " }
        if let bit = middleName, bit != "" { this += bit + " " }
        if let bit = lastName { this += bit }
        return this
    }
    
    /**
     Provides the string for the review cell
     */
    var reviewDescription: String {
        var this = ""
        
        if let birthdate = dateOfBirth {
            let dateFormatter: DateFormatter = {
                let this = DateFormatter()
                this.dateStyle = .long
                this.timeStyle = .none
                return this
            }()
            this += "Date of birth: \(dateFormatter.string(from: birthdate))\n" }
        
        if let age = age { this += "Age: \(age)\n" }
        
        var location = ""
        if let city = currentCity { location += city }
        if let state = currentState, state != "" { location += (location.isEmpty ? "" : ", ") +  state }
        if let country = currentCountry { location += (location.isEmpty ? "" : ", ") + country.name }
        if !location.isEmpty { this += "Location: \(location)\n" }
        
        var homeland = ""
        if let city = homeCity { homeland += city }
        if let state = homeState, state != "" { homeland += (location.isEmpty ? "" : ", ") +  state }
        if let country = homeCountry { homeland += (location.isEmpty ? "" : ", ") + country.name }
        if !homeland.isEmpty { this += "Hometown: \(homeland)\n" }
        
        if let timeAway = timeHomeless {
            this += "Time away from home: \(timeAway.value) \(timeAway.type)"
        }
        
        return this
    }
}
