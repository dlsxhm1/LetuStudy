//
//  KeyboardManager.swift
//  LetuStudy
//
//  Created by Richard Homan on 3/30/23.
//

import UIKit
import Combine

class KeyboardManager: ObservableObject
{
	@Published var keyboardHeight: CGFloat = 0
	@Published var isVisible = false
	
	private var keyboardShowCancellable: Cancellable?
	private var keyboardHideCancellable: Cancellable?
	
	init()
	{
		keyboardShowCancellable = NotificationCenter.default
			.publisher(for: UIWindow.keyboardWillShowNotification)
			.sink { [weak self] notification in
				guard let self = self else { return }
				
				guard let userInfo = notification.userInfo else { return }
				guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
				
				self.isVisible = keyboardFrame.maxY <= UIScreen.main.bounds.height
				self.keyboardHeight = self.isVisible ? keyboardFrame.height : 0
			}
		
		keyboardHideCancellable = NotificationCenter.default
			.publisher(for: UIWindow.keyboardDidHideNotification)
			.sink { [weak self] notification in
				guard let self = self else { return }
								
				self.isVisible = false
				self.keyboardHeight = 0.0
			}
	}
	
}
