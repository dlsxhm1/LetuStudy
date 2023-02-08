//
//  SettingsView.swift
//  LetuStudy
//
//  Created by Haoming Xu on 2/8/23.
//

import SwiftUI

enum UserType: String, CaseIterable {
	case Student
	case Instructor
	case Other
}

struct SettingsView: View {
	@State private var selectedUserType: UserType = .Student
	@State private var notificationToggle = true
	@State private var darkModeToggle = false
	@State private var soundToggle = true
	
	@State private var brightnessValue: Double = 75
	
	@State private var accessToggle = false
	@State private var colorReverseToggle = false
	@State private var ttsToggle = false
	
	var body: some View {
		NavigationView {
			VStack{
				Spacer()
					.frame(height: 10)
				Text("Settings")
					.font(.title)
					.fontWeight(.bold)
					.multilineTextAlignment(.leading)
					.padding(.trailing, 215.0)
				Form {
					Section(header: Text("Notifications settings")) {
						Toggle(isOn: $notificationToggle) {
							Text("Notification")
						}
					}
					
					Section(header: Text("Display settings")) {
						Toggle(isOn: $soundToggle) {
							Text("Dark Mode")
						}
						Text("Brightness Adjustment")
						Slider(value: $brightnessValue, in: 0...100)
					}
					
					Section(header: Text("General settings")) {
						Toggle(isOn: $soundToggle) {
							Text("Sound")
						}
						
						Picker(
							selection: $selectedUserType,
							label: Text("Select your role")
						) {
							ForEach(UserType.allCases, id: \.self) {
								Text($0.rawValue).tag($0)
							}
						}
					}
					
					Section(header: Text("Accessibility Settings")) {
						Toggle(isOn: $accessToggle) {
							Text ("Accessibility Mode")
						}
						if accessToggle {
							Section{
								Toggle(isOn: $colorReverseToggle) {
									Text("Reverse Color")
								}
								Toggle(isOn: $ttsToggle) {
									Text("VoiceOver")
								}
							}
						}
					}
				}
			}
			.background(Color(red: 242/255, green: 242/255, blue: 247/255))
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
