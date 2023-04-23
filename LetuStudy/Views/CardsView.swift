//
//  CardsView.swift
//  LetuStudy
//
//  Created by Haoming Xu on 2/8/23.
//

import SwiftUI
import CoreData

enum Focusable: Hashable
{
	case none
	case add
	case row(id: String)
}

struct CardsView: View
{
	@ObservedObject var keyboardManager = KeyboardManager()
	private var studySet : StudySet
	
	@State private var isEditing : Bool
	
	init(studySet: StudySet)
	{
		self.studySet = studySet
		self.isEditing = studySet.points.count == 0
	}
	
	var body: some View
	{
		NavigationStack
		{
			VStack()
			{
				if (self.isEditing)
				{
					CardsEditView(studySet: self.studySet)
				}
				else
				{
					CardsStudyView(studySet: self.studySet)
				}
			}
			.onAppear()
			{
				self.isEditing = studySet.points.count == 0
			}
			.navigationTitle("Study Cards")
			.navigationBarTitleDisplayMode(.large)
			.toolbar
			{
				ToolbarItem(placement: .navigationBarTrailing)
				{
					Button(action:
					{
						guard !keyboardManager.isVisible else
						{
							
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
				}
			}
		}
		.onDisappear()
		{
			print("dissapear")
		}
	}
	
	func fontSize(for text: String, in size: CGSize) -> CGFloat
	{
		let constrainedSize = CGSize(width: size.width - 20, height: .greatestFiniteMagnitude)
		let font = UIFont.boldSystemFont(ofSize: 30)
		let attributes: [NSAttributedString.Key: Any] = [.font: font]
		let attributedText = NSAttributedString(string: text, attributes: attributes)
		let boundingBox = attributedText.boundingRect(with: constrainedSize, options: .usesLineFragmentOrigin, context: nil)
		let availableHeight = size.height - 20
		let scaleFactor = min(availableHeight / boundingBox.height, 1.0)
		let fontSize = font.pointSize * scaleFactor
		return fontSize
	}
}

struct Card : View
{
	public let width : CGFloat
	public let height : CGFloat
	
	@Binding public var rotationAngle : Double
	@Binding public var textContent : String
	
	var body: some View
	{
		ZStack
		{
			RoundedRectangle(cornerRadius: 12)
				.fill(Color("LaunchColor"))
				.frame(width: width, height: height)
				.padding()
			Text(textContent)
				.font(.system(size: 32))
				.frame(width: width-10, height: height-30)
				.scaledToFill()
				.minimumScaleFactor(0.1)
				.padding()
		}.rotation3DEffect(Angle(degrees: rotationAngle), axis: (x: 0, y: 1, z: 0))
	}
}

struct CardsView_Previews: PreviewProvider
{
    static var previews: some View
	{
		CardsView(studySet: CardsPreviewConvenience.emptyStudySet())
			.previewDisplayName("Empty Set")
		CardsView(studySet: CardsPreviewConvenience.generatedStudySet())
			.previewDisplayName("Generated Set")
    }
}
