//
//  CardsView.swift
//  LetuStudy
//
//  Created by Haoming Xu on 2/8/23.
//

import SwiftUI

var words: [String] = [
	"Abstract Data Types",
	"Binary Tree",
	"Ancestor"
   ]

var definition: [String] = [
	"A data type that is defined by its behavior and operations, rather than its implementation",
	"A tree in which every node has at most two children and one node has no parent.",
	"A node on the path above a particular node to the root."
]


//var showDefinition = false

struct CardsView: View {
	
	@State var backDegree = 0.0
	@State var frontDegree = -90.0
	@State var isFlipped = false
	@State var currentIndex = 0
	
	let width : CGFloat = 300
	let height : CGFloat = 250
	let durationAndDelay : CGFloat = 0.15
	
	func flipCard () {
			isFlipped = !isFlipped
			if isFlipped {
				withAnimation(.linear(duration: durationAndDelay)) {
					backDegree = 90
				}
				withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
					frontDegree = 0
				}
			} else {
				withAnimation(.linear(duration: durationAndDelay)) {
					frontDegree = -90
				}
				withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
					backDegree = 0
				}
			}
		}
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .center, spacing: 20){
				Spacer()
				ZStack(){
					CardFront(width: width, height: height, degree: $frontDegree, currentIndex: $currentIndex)
					CardBack(width: width, height: height, degree: $backDegree, currentIndex: $currentIndex)
				}
				.onTapGesture {
					flipCard ()
				}
				HStack(){
					Spacer()
					Button("Previous") {
						if currentIndex > 0 {
							currentIndex -= 1
						}
						//Reset view to front (Word)
						isFlipped = false
					}
					.font(.system(size: 24))
					.disabled(currentIndex == 0)
//					.foregroundColor(isEnabled ? Color("LaunchColor") : .gray)
					
					Spacer()
					
					Button("Next") {
						if currentIndex < words.count - 1 {
							currentIndex += 1
						}
						//Reset view to front (Word)
						isFlipped = false
					}
					//.buttonStyle(.bordered)
					.font(.system(size: 24))
					.padding()
					//.background(Color("AccentColor"))
					//.foregroundColor(Color("LaunchColor"))
					//.cornerRadius(15)
					.disabled(currentIndex == words.count - 1)
					Spacer()
				}
				.padding()
				
//				Text("Show \(showDefinition ? "Word" : "Definition")")
//					.fontWeight(.bold)
//					.foregroundColor(Color("AccentColor"))
//					.font(.largeTitle)
//					.frame(width: 300, height: 150)
//					.background(Color("LaunchColor"))
//					.cornerRadius(15)
				
				//Flipping Effect
//					.rotation3DEffect(self.flipped ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
//					.onTapGesture {
//						withAnimation {
//							self.flipped.toggle()
//						}
//					}
			}
			Spacer()
			.frame(maxWidth: UIScreen.main.bounds.width)
			.navigationTitle("Study Cards")
			.navigationBarTitleDisplayMode(.large)
			
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

struct AddView: View{
	var body: some View {
		Text("Adding")
	}
}

struct CardFront : View {
	let width : CGFloat
	let height : CGFloat
	@Binding var degree : Double
	@Binding var currentIndex : Int
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 12)
				.fill(Color("LaunchColor"))
				.frame(width: width, height: height)
				.padding()
			Text(definition[currentIndex])
				.font(.system(size: 32))
				.foregroundColor(Color("AccentColor"))
				.frame(width: width-10, height: height-30)
				.scaledToFill()
				.minimumScaleFactor(0.1)
				.padding()
		}.rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
	}
}

struct CardBack : View {
	let width : CGFloat
	let height : CGFloat
	@Binding var degree : Double
	@Binding var currentIndex : Int
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 12)
				.fill(Color("LaunchColor"))
				.frame(width: width, height: height)
				.padding()
			Text(words[currentIndex])
				.font(.system(size: 40))
				.foregroundColor(Color("AccentColor"))
				.frame(width: width-10, height: height-30)
				.scaledToFill()
				.minimumScaleFactor(0.1)
				.padding()
				.lineLimit(2)
		}.rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
	}
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
    }
}
