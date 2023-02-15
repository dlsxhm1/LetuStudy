//
//  LoginView.swift
//  LetuStudy
//
//  Created by Haoming Xu on 2/13/23.
//

import SwiftUI

extension View {
	func hideKeyboard() {
		let resign = #selector(UIResponder.resignFirstResponder)
		UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
	}
}

struct LoginView: View {
	@State private var username: String = ""
	@State private var password: String = ""
	@State private var showPassword: Bool = false
	@State private var isAuthenticated: Bool = false
	@State private var isPasswordWrong: Bool = false
	
	//@FocusState private var nameIsFocused: Bool
	
	//Disable Sign-in button when Username or Password empty
	var isSignInButtonDisabled: Bool {
		[username, password].contains(where: \.isEmpty)
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 15) {
			Spacer()
			HStack {
				Spacer()
				Image("LaunchIcon")
					.resizable()
					.scaledToFit()
					.frame(width: 200, height: 200)
					.shadow(color: Color.black, radius: 2, x: 1, y: 1)
				Spacer()
			}
			Spacer()
			TextField("Name",
				  text: $username ,
				  prompt: Text("Username").foregroundColor(.gray)
			)
			.autocapitalization(.none)
			.disableAutocorrection(true)
			.textContentType(.username)
			.keyboardType(.asciiCapable)
			//.focused($nameIsFocused)
			.padding(15)
			.overlay {
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color("LoginColor"), lineWidth: 2)
			}
			.padding(.horizontal)
			
			HStack {
				ZStack {
					//Show or Hide password
					Group {
						if showPassword {
							TextField("Password",
								  text: $password,
								  prompt: Text("Password").foregroundColor(.gray))
							//.focused(true)
							.textContentType(.password)
							.autocapitalization(.none)
							.disableAutocorrection(true)
							.keyboardType(.asciiCapable)
						} else {
							SecureField("Password",
								text: $password,
								prompt: Text("Password").foregroundColor(.gray))
							//.focused(true)
							.textContentType(.password)
							.autocapitalization(.none)
							.disableAutocorrection(true)
							.keyboardType(.asciiCapable)
						}
					}
					.padding(15)
					.overlay {
						RoundedRectangle(cornerRadius: 10)
							.stroke(Color("LoginColor"), lineWidth: 2)
					}
					
					//Show or Hide password button
					HStack {
						Spacer()
						Button {
							showPassword.toggle()
						} label: {
							Image(systemName: showPassword ? "eye" : "eye.slash")
								.foregroundColor(showPassword ? .gray : .black)
						}
						.padding(.trailing)
					}
				}
			}.padding(.horizontal)
			
			Spacer()
			
			//			Button {
			//				if username == "example" && password == "password" {
			//					isAuthenticated = true
			//				} else {
			//
			//				}
			//			}

			Button{isAuthenticated = true}
			label: {
				Text("Sign In")
					.font(.title2)
					.bold()
					.foregroundColor(.white)
			}
			.frame(height: 50)
			.frame(maxWidth: .infinity)
			.background(
				isSignInButtonDisabled ?
				LinearGradient(colors: [.gray], startPoint: .topLeading, endPoint: .bottomTrailing) :
					LinearGradient(colors: [.accentColor], startPoint: .topLeading, endPoint: .bottomTrailing)
			)
			.cornerRadius(20)
			.disabled(isSignInButtonDisabled)
			.shadow(color: Color.gray.opacity(0.5), radius: 2, x: 1, y: 1)
			.padding()
			.contentShape(RoundedRectangle(cornerRadius: 20))
		}
//		.onTapGesture {
//			hideKeyboard()
//		}
		.fullScreenCover(isPresented: $isAuthenticated) {
			ContentView()
		}
	}
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
