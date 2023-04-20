//
//  CardsView.swift
//  LetuStudy
//
//  Created by Haoming Xu on 2/8/23.
//

import SwiftUI
import CoreData

struct CardsView: View
{
	@ObservedObject var keyboardManager = KeyboardManager()
	private var studySet : StudySet
	
	init(studySet: StudySet)
	{
		self.studySet = studySet
	}
	
	var body: some View
	{
		NavigationStack
		{
			VStack(alignment: .center, spacing: 20)
			{
				CardsEditView(studySet: self.studySet)
			}
			.frame(maxWidth: UIScreen.main.bounds.width)
			.navigationTitle("Study Cards")
			.navigationBarTitleDisplayMode(.large)
			.toolbar
			{
				ToolbarItem(placement: .navigationBarTrailing)
				{
					Button
					{
						
					}
				label:
					{
						Text("Edit")
					}
					.disabled(true)

//					Button(action:
//					{
//						guard !keyboardManager.isVisible else
//						{
//							focusedPoint = nil
//							return
//						}
//						withAnimation
//						{
//							self.isEditing = !isEditing
//						}
//					})
//					{
//						if (isEditing)
//						{
//							Text("Done")
//								.bold()
//						}
//						else
//						{
//							Text("Edit")
//						}
//					}
//					.transaction
//					{ t in
//						t.animation = .none
//					}
//					.disabled(!keyboardManager.isVisible && points.count <= 0)
				}
			}
			
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
    }
}
