//
//  StudycardView.swift
//  LetuStudy
//
//  Created by user237980 on 4/19/23.
//

import SwiftUI
import CoreData

struct SetsView: View {
	var managedObjectContext: NSManagedObjectContext =
	{
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.persistentContainer.viewContext
	}()

	@State var studySets :[StudySet] = []
	
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
					for studySet in fetchResult
					{
						print("name: \(studySet.name) lastOpened: \(studySet.lastOpened)")
					}
				}
    }
}

struct StudycardView_Previews: PreviewProvider
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
