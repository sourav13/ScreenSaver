//
//  ViewController.swift
//  ScreenSaver
//
//  Created by sourav sachdeva on 14/12/19.
//  Copyright © 2019 sourav sachdeva. All rights reserved.
//

import UIKit
import EventKitUI
import EventKit
class ViewController: UIViewController ,EKEventEditViewDelegate{
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        self.dismiss(animated: true, completion: nil)
    }
    
        let eventStore = EKEventStore()
    @IBOutlet weak var createEventButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        askPermission()
  
    }
    
    @IBAction func createEventButtonTapped(_ sender: UIButton) {
        
        let controller = EKEventEditViewController()
        controller.eventStore = eventStore
        controller.editViewDelegate  = self
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    func askPermission(){
      switch EKEventStore.authorizationStatus(for: .event) {
            case .authorized:
               createCalendar()
                case .denied:
                    print("Access denied")
                case .notDetermined:
                    eventStore.requestAccess(to: .event, completion:
                      {[weak self] (granted: Bool, error: Error?) -> Void in
                          if granted {
                            self?.createCalendar()
                        //    self!.insertEvent(store: self!.eventStore)
                          } else {
                                print("Access denied")
                          }
                    })
                    default:
                        print("Case default")
            }
    }
    func createCalendar(){
        let calendar = EKCalendar(for: .event, eventStore: eventStore)
        calendar.title = "EventCalendar"
        calendar.source = eventStore.defaultCalendarForNewEvents?.source
        do {
             try eventStore.saveCalendar(calendar, commit: true)
             createEvent(calendar: calendar)
        } catch { print(error) }
    }

    func createEvent(calendar:EKCalendar){

        let startDate = Date()
        let endDate = startDate.addingTimeInterval(2 * 60 * 60)

        let event = EKEvent(eventStore: eventStore)
        event.calendar = calendar
            
        event.title = "New Meeting"
        event.startDate = startDate
        event.endDate = endDate

        do {
            try eventStore.save(event, span: .thisEvent)
        }
        catch {
           print("Error saving event in calendar")
            
        }
    }


}

