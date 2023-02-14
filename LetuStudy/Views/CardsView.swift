//
//  CardsView.swift
//  LetuStudy
//
//  Created by Haoming Xu on 2/8/23.
//

import SwiftUI

struct CardsView: View {
	
	@State var flipped = false
	
	var body: some View {
		NavigationStack {
			VStack(){
				ScrollView {
					VStack(alignment: .center, spacing: 20) {
						ForEach(1..<6) {
							Text("Vocabulary \($0)")
								.fontWeight(.bold)
								.foregroundColor(Color("AccentColor"))
								.font(.largeTitle)
								.frame(width: 300, height: 150)
								.background(Color("LaunchColor"))
								.cornerRadius(15)
								
								//Flipping Effect
								.rotation3DEffect(self.flipped ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
								.onTapGesture {
									withAnimation {
										self.flipped.toggle()
									}
								}
						}
					}
				}
				.frame(maxWidth: UIScreen.main.bounds.width)
				.navigationTitle("Study Cards")
				.navigationBarTitleDisplayMode(.large)
			}
		}
	}
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
    }
}
