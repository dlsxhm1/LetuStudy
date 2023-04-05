//
//  CardsView.swift
//  LetuStudy
//
//  Created by Haoming Xu on 2/8/23.
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

struct CardsView: View
{
	@ObservedObject private var keyboardManager = KeyboardManager()
	
	enum Focusable: Hashable
	{
		case none
		case add
		case row(id: String)
	}
	@FocusState var focusedPoint: Focusable?
	
	@State private var frontAngle = 0.0
	@State private var backAngle = 90.0
	@State private var isFlipped = false
	@State private var studyingIndex = 0
	
	@State private var isEditing = false
	
	@State private var points: [Point] = []
	
	private let cardWidth : CGFloat = 300
	private let cardHeight : CGFloat = 250
	private let cardAnimationDuration : CGFloat = 0.15
	
	var persistentStore: NSPersistentContainer =
	{
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.persistentContainer
	}()
	
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
		NavigationStack
		{
			VStack(alignment: .center, spacing: 20)
			{
				if (!isEditing)
				{
					if (points.count <= 0)
					{
						Text("Select \"Edit\" to add terms")
							.onAppear
						{
							isEditing = true
						}
					}
					else
					{
						ZStack()
						{
							// front card
							Card(width: cardWidth, height: cardHeight, rotationAngle: $frontAngle, textContent: $points[studyingIndex].term)
							// back card
							Card(width: cardWidth, height: cardHeight, rotationAngle: $backAngle, textContent: $points[studyingIndex].description)
						}
						.onTapGesture
						{
							flipCard ()
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
								if studyingIndex < points.count - 1
								{
									studyingIndex += 1
								}
								//Reset view to front (Word)
	//							isFlipped = false
							}
								.font(.system(size: 24))
								.padding()
								.disabled(studyingIndex >= points.count - 1)
							Spacer()
						}
						.padding()
					}
				}
				else
				{
					List()
					{
						ForEach(0..<points.count, id: \.self)
						{
							index in
							
							HStack()
							{
								Text("\(index+1)")
									.padding(.trailing)
								VStack(alignment: .leading)
								{
									TextField("Term", text: self.$points[index].term)
										.focused($focusedPoint, equals: .row(id: UUID().uuidString))
										.submitLabel(.done)
									Divider()
									TextField("Definition", text: self.$points[index].description)
										.focused($focusedPoint, equals: .row(id: UUID().uuidString))
										.submitLabel(.done)
								}
							}
						}
						.onDelete
						{
							indexSet in
							self.points.remove(atOffsets: indexSet)
						}
						
						Button(action:
						{
							self.focusedPoint = .add
							withAnimation {
								self.points.append(Point(term: "", description: ""))
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
			.frame(maxWidth: UIScreen.main.bounds.width)
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
		.onAppear()
		{
			let studySetFetchRequest = StudySet.fetchRequest()
			var fetchResult: [StudySet]?
			
			persistentStore.viewContext.performAndWait {
				do
				{
					fetchResult = try persistentStore.viewContext.fetch(studySetFetchRequest)
				}
				catch
				{
					print("Error counting objects: \(error)")
				}
			}
			
			guard fetchResult != nil && fetchResult!.count > 0 else
			{
				print("Could not fetch results")
				return
			}
			
			let firstSet = fetchResult![0]
			print("name: \(firstSet.name) lastOpened: \(firstSet.lastOpened)")
		}
	}
	
	func fontSize(for text: String, in size: CGSize) -> CGFloat {
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
				.foregroundColor(Color("AccentColor"))
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
		CardsView()
    }
}
