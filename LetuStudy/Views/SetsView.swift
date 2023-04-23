//
//  StudycardView.swift
//  LetuStudy
//
//  Created by user237980 on 4/19/23.
//

import SwiftUI
import CoreData

struct SetsView: View
{
	@State private var showingNewSetAlert = false
	@State private var newSetName = ""
	
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
					NavigationLink(setName, destination: CardsView(parentView: self, studySet: studySet))
				}
			}
			.navigationTitle("Study Sets")
			.navigationBarTitleDisplayMode(.large)
			.toolbar
			{
				ToolbarItem(placement: .navigationBarTrailing)
				{
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
			
			self.studySets = fetchResult
			self.sortStudySets()
		}
    }
	
	func sortStudySets()
	{
		self.studySets.sort
		{ o1,o2 in
			return o1.lastOpened > o2.lastOpened
		}
	}
	
	func submitNewStudySet()
	{
		let newSet = StudySet(context: self.managedObjectContext)
		newSet.name = newSetName
		newSet.lastOpened = Date()
		
		withAnimation
		{
			self.studySets.insert(newSet, at: 0)
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
