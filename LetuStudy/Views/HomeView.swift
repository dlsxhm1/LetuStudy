//
//  Home.swift
//  LetuStudy
//
//  Created by Haoming Xu on 2/8/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View{
        VStack {
            Spacer()
                .frame(height: 50)
            Image("Mark_Spenser")
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundColor(.white)
                .padding(0)
                .clipShape(Circle())
            
            //Title
            VStack(alignment: .center) {
                Text("Welcome Back,")
                    .font(.title)
                Text("Mark Spensor")
                    .font(.title)
				Spacer()
					.frame(height: 50.0)
                VStack() {
                    Text("Last study set:             Vocabulary 1\n\nLast opened:       02/08/2023 18:32")
                        .font(.subheadline)
						.padding()
						.overlay(
								RoundedRectangle(cornerRadius: 16)
									.stroke(Color(red: 168/255, green: 170/255, blue: 175/255), lineWidth: 4)
							)
                    Text("")
                        .font(.subheadline)
				}
				//.frame(width: 300.0, height: 350.0)
				
				Spacer()
            }
			
            .padding()
            
            Spacer()
        }
        .frame(width: 350.0)
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
