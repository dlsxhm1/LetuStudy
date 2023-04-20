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
					NavigationLink(setName, destination: CardsView(studySet: studySet))
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
			
			studySets = fetchResult
		}
    }
	
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
