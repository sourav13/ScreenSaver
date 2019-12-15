////
////  EventManager.swift
////  ScreenSaver
////
////  Created by sourav sachdeva on 14/12/19.
////  Copyright © 2019 sourav sachdeva. All rights reserved.
////
//
//import Foundation
//import EventKit
//import EventKitUI
////typealias EventsCalendarManagerResponse = (_ result: ResultCustomError<Bool, CustomError>) -> Void
//class EventManager: NSObject{
//    var eventStore : EKEventStore!
//    override init(){
//        eventStore = EKEventStore()
//    }
//    private func requestAccess(completion: @escaping EKEventStoreRequestAccessCompletionHandler) {
//          eventStore.requestAccess(to: EKEntityType.event) { (accessGranted, error) in
//              completion(accessGranted, error)
//          }
//      }
//    private func getAuthorizationStatus() -> EKAuthorizationStatus {
//         return EKEventStore.authorizationStatus(for: EKEntityType.event)
//     }
//    private func generateEvent(event: Event) -> EKEvent {
//           let newEvent = EKEvent(eventStore: eventStore)
//           newEvent.calendar = eventStore.defaultCalendarForNewEvents
//           newEvent.title = event.name
//           newEvent.startDate = event.dateStart
//           newEvent.endDate = event.dateEnd
//           // Set default alarm minutes before event
//           let alarm = EKAlarm(relativeOffset: TimeInterval(Configuration.addEventToCalendarAlarmMinutesBefore()*60))
//           newEvent.addAlarm(alarm)
//           return newEvent
//       }
//       
//       // Try to save an event to the calendar
//       
//       private func addEvent(event: Event, completion : @escaping EventsCalendarManagerResponse) {
//           let eventToAdd = generateEvent(event: event)
//           if !eventAlreadyExists(event: eventToAdd) {
//               do {
//                   try eventStore.save(eventToAdd, span: .thisEvent)
//               } catch {
//                   // Error while trying to create event in calendar
//                   completion(.failure(.eventNotAddedToCalendar))
//               }
//               completion(.success(true))
//           } else {
//               completion(.failure(.eventAlreadyExistsInCalendar))
//           }
//         
//       }
//       
//       // Check if the event was already added to the calendar
//       
//       private func eventAlreadyExists(event eventToAdd: EKEvent) -> Bool {
//           let predicate = eventStore.predicateForEvents(withStart: eventToAdd.startDate, end: eventToAdd.endDate, calendars: nil)
//           let existingEvents = eventStore.events(matching: predicate)
//           
//           let eventAlreadyExists = existingEvents.contains { (event) -> Bool in
//               return eventToAdd.title == event.title && event.startDate == eventToAdd.startDate && event.endDate == eventToAdd.endDate
//           }
//           return eventAlreadyExists
//       }
//    func addEventToCalendar(event: Event, completion : @escaping EventsCalendarManagerResponse) {
//        let authStatus = getAuthorizationStatus()
//        switch authStatus {
//        case .authorized:
//            self.addEvent(event: event, completion: { (result) in
//                switch result {
//                case .success:
//                    completion(.success(true))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            })
//        case .notDetermined:
//            //Auth is not determined
//            //We should request access to the calendar
//            requestAccess { (accessGranted, error) in
//                if accessGranted {
//                    self.addEvent(event: event, completion: { (result) in
//                        switch result {
//                        case .success:
//                            completion(.success(true))
//                        case .failure(let error):
//                            completion(.failure(error))
//                        }
//                    })
//                } else {
//                    // Auth denied, we should display a popup
//                    completion(.failure(.calendarAccessDeniedOrRestricted))
//                }
//            }
//        case .denied, .restricted:
//            // Auth denied or restricted, we should display a popup
//            completion(.failure(.calendarAccessDeniedOrRestricted))
//        }
//    }
//}
