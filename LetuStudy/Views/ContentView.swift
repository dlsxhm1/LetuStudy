//
//  ContentView.swift
//  LetuStudy
//
//  Created by Haoming Xu on 2/7/23.
//

import SwiftUI
import RealityKit

struct ContentView : View {
	@State public var tabViewSelection = 0
	
	//Detects if logged in
	@State var currentUsername = ""
	
	//Defines bar size for sliding bar animation
	private var singleTabWidth = UIScreen.main.bounds.width / 4
	
	init() {
		//Change Tab Bar background color
		//UITabBar.appearance().isTranslucent = true
		//UITabBar.appearance().barTintColor = UIColor(named: "AccentColor")
	}
	
    var body: some View {
		ZStack(alignment: .bottomLeading) {
			//Tab Bar
			TabView(selection: $tabViewSelection){
				HomeView()
					.tabItem {
						Image(systemName:"house")
						Text("Home")
					}.tag(0)
					.foregroundColor(Color("AccentColor"))
				CardsView()
					.tabItem {
						Image(systemName: "rectangle.on.rectangle.angled")
						Text("Study Cards")
					}.tag(1)
					.foregroundColor(Color("AccentColor"))
				StatsView()
					.tabItem {
						Image(systemName: "chart.bar.xaxis")
						Text("Statistics")
					}.tag(2)
					.foregroundColor(Color("AccentColor"))
				SettingsView()
					.tabItem {
						Image(systemName: "gear")
						Text("Settings")
					}.tag(3)
					.foregroundColor(Color("AccentColor"))
			}
			.padding(.bottom, 10.0)
			.accentColor(Color("AccentColor"))
			
			//Sliding Animtion
			Rectangle()
				.offset(x: singleTabWidth * CGFloat(tabViewSelection))
				.frame(width: singleTabWidth, height: 7)
				.padding(.bottom, 20.0)
				.animation(.default, value: tabViewSelection)
			
		}
		.edgesIgnoringSafeArea(.bottom)
        //ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}


struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
