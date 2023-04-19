//
//  CardsEditView.swift
//  LetuStudy
//
//  Created by Richard Homan on 4/19/23.
//

import SwiftUI
import CoreData

struct Point
{
	public var term: String
	public var description: String
	
	init(term: String, description: String)
	{
		self.term = term
		self.description = description
	}
}

struct CardsEditView : View
{
	@State private var studyPoints : [StudyPoint] = []
	private var studySet : StudySet
	
	@ObservedObject private var keyboardManager = KeyboardManager()
	
	enum Focusable: Hashable
	{
		case none
		case add
		case row(id: String)
	}
	@FocusState var focusedPoint: Focusable?

	init(studySet: StudySet)
	{
		self.studySet = studySet
		self.studyPoints = studySet.points.array as! [StudyPoint]
	}
	
	var body: some View
	{
		List()
		{
			ForEach(0..<self.studyPoints.count, id: \.self)
			{
				index in
				
				HStack()
				{
					Text("\(index+1)")
						.padding(.trailing)
					VStack(alignment: .leading)
					{
						TextField("Term", text: self.$studyPoints[index].term)
							.focused($focusedPoint, equals: .row(id: UUID().uuidString))
							.submitLabel(.done)
						Divider()
						TextField("Definition", text: self.$studyPoints[index].definition)
							.focused($focusedPoint, equals: .row(id: UUID().uuidString))
							.submitLabel(.done)
					}
				}
			}
			.onDelete
			{
				indexSet in
				self.studyPoints.remove(atOffsets: indexSet)
			}
			
			Button(action:
			{
				self.focusedPoint = .add
				withAnimation
				{
					let newPoint = StudyPoint(context: self.studySet.managedObjectContext!)
					newPoint.term = ""
					newPoint.definition = ""
					self.studyPoints.append(newPoint)
					self.studySet.addToPoints(newPoint)
				}
			} ,label:
			{
				HStack()
				{
					ZStack {
						Image(systemName: "circle.fill")
							.foregroundColor(.white)
							.padding(.leading, 0)
							.font(.system(size: 18))
						Image(systemName: "plus.circle.fill")
							.foregroundColor(.green)
							.padding(.leading, 0)
							.font(.system(size: 18))
					}
					
					Text("Add")
						.padding(.leading, 8.0)
				}
			})
			.focused($focusedPoint, equals: .add)
		}
	}
}

struct CardsEditView_Previews: PreviewProvider
{	
	static var previews: some View
	{
		CardsEditView(studySet: CardsPreviewConvenience.emptyStudySet())
			.previewDisplayName("Empty Set")
		CardsEditView(studySet: CardsPreviewConvenience.generatedStudySet())
			.previewDisplayName("Generated Set")
	}
}
