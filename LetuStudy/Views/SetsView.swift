//
//  StudycardView.swift
//  LetuStudy
//
//  Created by user237980 on 4/19/23.
//

import SwiftUI
import CoreData

struct SetsView: View {
	@ObservedObject private var keyboardManager = KeyboardManager()
	
	enum Focusable: Hashable
	{
		case none
		case add
		case row(id: String)
	}
	
	@FocusState var focusedPoint: Focusable?
	@State private var isEditing = false
	@State private var points: [Point] = []

	
	var persistentStore: NSPersistentContainer =
	{
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.persistentContainer
	}()
	
	var studysets: [Studyset] = [.init(name: "StudySet 1"), .init(name: "StudySet 2"), .init(name: "StudySet 3"),]
	
    var body: some View {
		NavigationStack{
			List{
				ForEach(studysets, id: \.id)
				{ studySet in
					let setName = studySet.name
					NavigationLink(setName, destination: CardsView())
				}
			}
			.navigationTitle("Study Sets")
			.navigationBarTitleDisplayMode(.large)
			.toolbar
			{
				ToolbarItem(placement: .navigationBarTrailing)
				{
					Button(action:
					{
						guard !keyboardManager.isVisible else
						{
							focusedPoint = nil
							return
						}
						withAnimation
						{
							self.isEditing = !isEditing
						}
					})
					{
						if (isEditing)
						{
							Text("Done")
								.bold()
						}
						else
						{
							Text("Edit")
						}
					}
					.transaction
					{ t in
						t.animation = .none
					}
					.disabled(!keyboardManager.isVisible && points.count <= 0)
				}
			}
		}
		
    }
}

struct StudycardView_Previews: PreviewProvider {
    static var previews: some View {
        SetsView()
    }
}

struct Studyset: Identifiable, Hashable {
	let id: String = UUID().uuidString
	let name: String
}
