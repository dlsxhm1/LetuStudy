//
//  CardsView.swift
//  LetuStudy
//
//  Created by Haoming Xu on 2/8/23.
//

import SwiftUI

struct CardsView: View {
	var body: some View {
		VStack(){
			Spacer()
				.frame(height: 20)
			Text("Study Cards")
				.font(.largeTitle)
				.multilineTextAlignment(.leading)
				.padding(.trailing, 150.0)
			Spacer()
				.frame(height: 50)
			ScrollView {
				VStack(alignment: .center, spacing: 20) {
					ForEach(1..<6) {
						Text("Vocabulary \($0)")
							.fontWeight(.bold)
							.foregroundColor(Color(red: 31/255, green: 46/255, blue: 96/255))
							.font(.largeTitle)
							.frame(width: 300, height: 150)
							.background(Color(red: 223/255, green: 183/255, blue: 87/255))
							.cornerRadius(15)
					}
				}
				
			}
			
		}
	}
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
    }
}
