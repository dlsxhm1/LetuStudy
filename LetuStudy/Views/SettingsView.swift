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
	@Environment(\.colorScheme) var colorScheme
	
	@State private var selectedUserType: UserType = .Student
	@State private var notificationToggle = true
	@State private var darkModeToggle = false
	@State private var soundToggle = true
	
	@State private var brightnessValue: Double = 75
	
	@State private var accessToggle = false
	@State private var colorReverseToggle = false
	@State private var ttsToggle = false
	
	var body: some View {
		NavigationStack {
			VStack{
				Form {
					Section(header: Text("Notifications settings")) {
						Toggle(isOn: $notificationToggle) {
							Text("Notification")
						}.tint(Color("AccentColor"))
					}
					
					Section(header: Text("Display settings")) {
						Toggle(isOn: $darkModeToggle) {
							Text("Dark Mode")
						}.tint(Color("AccentColor"))
						Text("Brightness Adjustment")
						Slider(value: $brightnessValue, in: 0...100).tint(Color("AccentColor"))
					}
					
					Section(header: Text("General settings")) {
						Toggle(isOn: $soundToggle) {
							Text("Sound")
						}.tint(Color("AccentColor"))
						
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
						}.tint(Color("AccentColor"))
						if accessToggle {
							Section{
								Toggle(isOn: $colorReverseToggle) {
									Text("Reverse Color")
								}.tint(Color("AccentColor"))
								Toggle(isOn: $ttsToggle) {
									Text("VoiceOver")
								}.tint(Color("AccentColor"))
							}
						}
					}
				}
				.navigationTitle("Settings")
			}
			//.background(Color(.systemGroupedBackground))
		}
		.edgesIgnoringSafeArea(.bottom)
	}
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
