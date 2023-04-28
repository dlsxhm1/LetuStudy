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
				ForEach(self.studySets, id: \.id)
				{ studySet in
					let setName = studySet.name
					NavigationLink(setName, destination: CardsView(parentView: self, studySet: studySet))
				}
				.onDelete
				{ indexSet in
					for i in indexSet
					{
						let set = self.studySets[i]
						self.managedObjectContext.delete(set)
					}
					self.studySets.remove(atOffsets: indexSet)
					
					Task
					{
						await AppDelegate.shared.saveContext()
					}
				}
			}
			.navigationTitle("Study Sets")
			.navigationBarTitleDisplayMode(.large)
			.toolbar
			{
				ToolbarItem(placement: .navigationBarTrailing)
				{
					HStack
					{
						Picker("Time", selection: $timerVal)
						{
							ForEach(0..<61)
							{ minute in
								Text("\(minute) min")
							}
						}
						Button(action:
						{
							scheduleNotification()
						})
						{
							Text("Set Time")
						}
						Button
						{
							self.showingNewSetAlert.toggle()
							self.newSetName = ""
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
			self.studySets = StudySet.fetchAll()
			self.sortStudySets()
		}
    }
	
	func sortStudySets()
	{
		self.studySets = StudySet.dateSorted(studySets: self.studySets)
	}
  
	func scheduleNotification()
	{
		if timerVal > 0
		{
			let content = UNMutableNotificationContent()
			content.title = "Time is up!"
			content.body = "Your \(timerVal) minute timer has expired."
			let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timerVal * 6), repeats: false)
			let request = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)
			UNUserNotificationCenter.current().add(request)
			{ (error) in
				if error != nil {
					print(error?.localizedDescription ?? "Unknown error")
				}
			}
			let dispatchTime = DispatchTime.now() + .seconds(timerVal * 6)
			DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
				if UIApplication.shared.applicationState == .active
				{
					// App is in the foreground, show an alert
					let alert = UIAlertController(title: "Time to study!", message: "Its time to start studying with LetuStudy!", preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
					UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
				}
				else
				{
					// App is in the background, show a notification
					let notification = UNMutableNotificationContent()
					notification.title = "Time to study!"
					notification.body = "Its time to start studying with LetuStudy!"
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
		let newSet = StudySet(context: self.managedObjectContext)
		newSet.name = newSetName
		newSet.lastOpened = Date()
		
		withAnimation
		{
			self.studySets.insert(newSet, at: 0)
		}
		
		Task
		{
			await AppDelegate.shared.saveContext()
		}
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
