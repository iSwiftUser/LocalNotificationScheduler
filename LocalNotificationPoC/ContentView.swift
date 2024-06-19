//
//  ContentView.swift
//  LocalNotificationPoC
//
//  Created by Gaurav Sharma on 18/06/24.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State var notificationList = [String]()
    
    var body: some View {
        VStack {
            Button(action: {
                self.showDatePicker.toggle()
            }) {
                Text("Schedule Notification")
                    .foregroundColor(!self.showDatePicker ? Color.white : Color.blue)
                    .padding()
                    .background(!self.showDatePicker ? Color.blue : Color.white)
                    .cornerRadius(10)
            }.padding(.top, 40)
            
            if showDatePicker {
                withAnimation(.easeIn) {
                    DatePicker(
                        "Select a date",
                        selection: Binding(
                            get: { self.selectedDate },
                            set: { newValue in
                                self.selectedDate = newValue
                                self.showDatePicker = false  // Dismiss the DatePicker
                                self.scheduleNotification()
                            }
                        ),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.automatic)
                    .padding()
                }
            }
            
            List(self.notificationList, id: \.self) { scheduledDate in
                Text(scheduledDate)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Notification Scheduled"),
                message: Text(self.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "This is your scheduled notification."
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .short
                let formattedDate = dateFormatter.string(from: self.selectedDate)
                self.alertMessage = "Notification scheduled for \(formattedDate)"
                self.showAlert = true
                self.notificationList.append(self.alertMessage)
            }
        }
    }
}

#Preview {
    ContentView()
}
