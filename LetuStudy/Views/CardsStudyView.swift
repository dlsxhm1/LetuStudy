//
//  CardsStudyView.swift
//  LetuStudy
//
//  Created by Richard Homan on 4/19/23.
//

import SwiftUI
import CoreData

struct CardsStudyView : View
{
	private let cardWidth : CGFloat = 300
	private let cardHeight : CGFloat = 250
	private let cardAnimationDuration : CGFloat = 0.15

	@State private var frontAngle = 0.0
	@State private var backAngle = 90.0
	@State private var isFlipped = false
	@State private var studyingIndex = 0

	@State public var studyPoints : [StudyPoint]
	
	init(studyPoints: [StudyPoint])
	{
		self.studyPoints = studyPoints
	}
	
	func flipCard()
	{
		isFlipped = !isFlipped
		if isFlipped
		{
			withAnimation(.linear(duration: cardAnimationDuration))
			{
				frontAngle = -90.0
			}
			withAnimation(.linear(duration: cardAnimationDuration).delay(cardAnimationDuration))
			{
				backAngle = 0.0
			}
		}
		else
		{
			withAnimation(.linear(duration: cardAnimationDuration))
			{
				backAngle = 90.0
			}
			withAnimation(.linear(duration: cardAnimationDuration).delay(cardAnimationDuration))
			{
				frontAngle = 0.0
			}
		}
	}
	
	var body: some View
	{
		guard self.studyPoints.count > 0 else
		{
			return AnyView(Text("Select \"Edit\" to add terms"))
		}
		
		return AnyView(VStack(alignment: .center, spacing: 20)
		{
			ZStack()
			{
				// front card
				CardView(width: cardWidth, height: cardHeight, rotationAngle: $frontAngle, textContent: self.$studyPoints[studyingIndex].term)
				// back card
				CardView(width: cardWidth, height: cardHeight, rotationAngle: $backAngle, textContent: self.$studyPoints[studyingIndex].definition)
			}
			.onTapGesture
			{
				flipCard()
			}
			HStack(){
				Spacer()
				Button("Previous")
				{
					if studyingIndex > 0
					{
						studyingIndex -= 1
					}
					//Reset view to front (Word)
					//							isFlipped = false
				}
				.font(.system(size: 24))
				.disabled(studyingIndex <= 0)
				Spacer()
				Button("Next")
				{
					if studyingIndex < self.studyPoints.count - 1
					{
						studyingIndex += 1
					}
					//Reset view to front (Word)
					//							isFlipped = false
				}
				.font(.system(size: 24))
				.padding()
				.disabled(studyingIndex >= self.studyPoints.count - 1)
				Spacer()
			}
			.padding()
		})
	}
}

struct CardView : View
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

struct CardsStudyView_Previews: PreviewProvider
{
	static var emptyStudyPoints : [StudyPoint] = []
	
	static var generatedStudyPoints : [StudyPoint] =
	{
		let numPoints = 5
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let moc = appDelegate.persistentContainer.viewContext
		var buildArr : [StudyPoint] = []
		
		for i in 1...numPoints
		{
			let someStudyPoint = StudyPoint(context: moc)
			someStudyPoint.term = "Term \(i)"
			someStudyPoint.definition = "Definition \(i)"
			buildArr.append(someStudyPoint)
		}
		
		return buildArr
	}()
	
	static var previews: some View
	{
		CardsStudyView(studyPoints: emptyStudyPoints)
			.previewDisplayName("No Study Points")
		CardsStudyView(studyPoints: generatedStudyPoints)
			.previewDisplayName("With Study Points")
	}
}
