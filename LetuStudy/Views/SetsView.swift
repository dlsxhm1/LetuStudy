//
//  StudycardView.swift
//  LetuStudy
//
//  Created by user237980 on 4/19/23.
//

import SwiftUI
import CoreData
import UserNotifications

struct SetsView: View
{
	@State private var isPickerVisible = false
	@State private var showingNewSetAlert = false
	@State private var newSetName = ""
	@State var timerVal = 0
	@State var secondScreenShown = false
	
	var managedObjectContext: NSManagedObjectContext =
	{
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.persistentContainer.viewContext
	}()

	@State var studySets : [StudySet] = []
	
    var body: some View
	{
		NavigationStack
		{
			List
			{
				ForEach(studySets, id: \.id)
				{ studySet in
					let setName = studySet.name
					NavigationLink(setName, destination: CardsView(studySet: studySet))
				}
			}
			.navigationTitle("Study Sets")
			.navigationBarTitleDisplayMode(.large)
			.toolbar
			{
				ToolbarItem(placement: .navigationBarTrailing)
				{
					HStack {
						Picker("Time", selection: $timerVal) {
							ForEach(0..<61) { minute in
								Text("\(minute) min")
							}
						}
						Button(action: {
							scheduleNotification()
						}) {
							Text("Set Time")
						}
						Button
						{
							self.showingNewSetAlert.toggle()
						}
					label:
						{
							Image(systemName: "plus.circle")
						}
						.alert("New Study Set", isPresented: self.$showingNewSetAlert) {
							TextField("Name", text:$newSetName)
							Button("OK", action: submitNewStudySet)
							Button("Cancel", role: .cancel) {}
						} message: {
							Text("Enter the name of the new study set")
						}
					}
				}
			}
		}
		.onAppear()
		{
			// load study sets
			let studySetFetchRequest = StudySet.fetchRequest()
			var fetchResultOpt: [StudySet]?
			
			managedObjectContext.performAndWait
			{
				do
				{
					fetchResultOpt = try managedObjectContext.fetch(studySetFetchRequest)
				}
				catch
				{
					print("Error fetching study sets: \(error)")
				}
			}
			
			guard fetchResultOpt != nil && fetchResultOpt!.count > 0 else
			{
				print("No study sets found")
				return
			}
			
			let fetchResult = fetchResultOpt!
			
			studySets = fetchResult
		}
    }
	
	func scheduleNotification() {
		if timerVal > 0 {
			let content = UNMutableNotificationContent()
			content.title = "Time is up!"
			content.body = "Your \(timerVal) minute timer has expired."
			let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timerVal * 6), repeats: false)
			let request = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)
			UNUserNotificationCenter.current().add(request) { (error) in
				if error != nil {
					print(error?.localizedDescription ?? "Unknown error")
				}
			}
			let dispatchTime = DispatchTime.now() + .seconds(timerVal * 6)
			DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
				if UIApplication.shared.applicationState == .active {
					// App is in the foreground, show an alert
					let alert = UIAlertController(title: "Time is up!", message: "Your \(timerVal) minute timer has expired.", preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
					UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
				} else {
					// App is in the background, show a notification
					let notification = UNMutableNotificationContent()
					notification.title = "Time is up!"
					notification.body = "Your \(timerVal) minute timer has expired."
					notification.sound = .default
					let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
					let notificationRequest = UNNotificationRequest(identifier: "timer", content: notification, trigger: notificationTrigger)
					UNUserNotificationCenter.current().add(notificationRequest) { (error) in
						if error != nil {
							print(error?.localizedDescription ?? "Unknown error")
						}
					}
				}
			}
		}
	}
//	var pickerSheet: some View {
//		Picker("Time", selection: $timerVal) {
//			ForEach(0..<61) { minute in
//				Text("\(minute) min")
//			}
//		}
//		.pickerStyle(WheelPickerStyle())
//		.frame(height: 150)
//	}
	
	func submitNewStudySet()
	{
		
	}
}

struct SetsView_Previews: PreviewProvider
{
    static var previews: some View
	{
        SetsView()
    }
}

struct Studyset: Identifiable, Hashable
{
	let id: String = UUID().uuidString
	let name: String
}
