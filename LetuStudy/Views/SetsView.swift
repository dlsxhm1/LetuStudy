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
