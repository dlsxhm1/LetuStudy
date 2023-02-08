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
	@State var selection = 0
	private var singleTabWidth = UIScreen.main.bounds.width / 4
	
	init() {
		UITabBar.appearance().backgroundColor = UIColor.white
	}
	
    var body: some View {
		ZStack(alignment: .bottomLeading) {
			TabView(selection: $tabViewSelection){
				HomeView()
					.tabItem {
						if selection == 0 {
							Image(systemName:"house")
						} else {
							Image(systemName:"house.fill")
						}
						Text("Home")
					}.tag(0)
				CardsView()
					.tabItem {
						if selection == 0 {
							Image(systemName: "rectangle.and.paperclip")
						} else {
							Image(systemName: "rectangle.and.paperclip.fill")
						}
						Text("Study Cards")
					}.tag(1)
				StatsView()
					.tabItem {
						Image(systemName: "chart.bar.xaxis")
						Text("Statistics")
					}.tag(2)
				SettingsView()
					.tabItem {
						Image(systemName: "gear")
						Text("Settings")
					}.tag(3)
			}

			.padding(.bottom, 10.0)
			Rectangle()
				.offset(x: singleTabWidth * CGFloat(tabViewSelection))
				.frame(width: singleTabWidth, height: 7)
				.padding(.bottom, 0.0)
				.animation(.default)
		}
		
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
