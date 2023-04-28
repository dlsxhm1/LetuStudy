//
//  ContentView.swift
//  LetuStudy
//
//  Created by Haoming Xu on 2/7/23.
//

import SwiftUI
import UserNotifications
//import RealityKit

struct ContentView : View {
	@State public var tabViewSelection = 0
	
	//Detects if logged in
	@State var currentUsername = ""
	
	//Defines bar size for sliding bar animation
	private var singleTabWidth = UIScreen.main.bounds.width / 2
	
	init() {
		UIApplication.shared.applicationIconBadgeNumber = -1
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			if granted {
				print("Notification Permission Granted")
			} else if let error = error {
				print(error.localizedDescription)
			}
		}
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
//		.alert(isPresented: $notiAlert) { () -> Alert in
//			Alert(title: Text("Notification Permission Denied"),
//				  message: Text("Some functions might not working properly."),
//				  primaryButton: .default(Text("Settings"), action: {
//						UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)}),
//				  secondaryButton: .default(Text("Cancel")))
//		}
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
