//
//  ContentView.swift
//  LetuStudy
//
//  Created by Haoming Xu on 2/7/23.
//

import SwiftUI
//import RealityKit

struct ContentView : View {
	@State public var tabViewSelection = 0
	
	//Detects if logged in
	@State var currentUsername = ""
	
	//Defines bar size for sliding bar animation
	private var singleTabWidth = UIScreen.main.bounds.width / 2
	
	init() {
		//Change Tab Bar background color
		//UITabBar.appearance().isTranslucent = true
		//UITabBar.appearance().barTintColor = UIColor(named: "AccentColor")
	}
	
    var body: some View {
		ZStack(alignment: .bottomLeading) {
			//Tab Bar
			TabView(selection: $tabViewSelection){
//				HomeView()
//					.tabItem {
//						Image(systemName:"house")
//						Text("Home")
//					}.tag(0)
				SetsView()
					.tabItem {
						Image(systemName: "rectangle.on.rectangle.angled")
						Text("Study Cards")
					}.tag(0)
				StatsView()
					.tabItem {
						Image(systemName: "chart.bar.xaxis")
						Text("Statistics")
					}.tag(1)
//				SettingsView()
//					.tabItem {
//						Image(systemName: "gear")
//						Text("Settings")
//					}.tag(3)
			}
			.padding(.bottom, 10.0)
			
			//Sliding Animtion
			Rectangle()
				.offset(x: singleTabWidth * CGFloat(tabViewSelection))
				.frame(width: singleTabWidth, height: 7)
				.padding(.bottom, 20.0)
				.animation(.default, value: tabViewSelection)
			
		}
		.edgesIgnoringSafeArea(.bottom)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
