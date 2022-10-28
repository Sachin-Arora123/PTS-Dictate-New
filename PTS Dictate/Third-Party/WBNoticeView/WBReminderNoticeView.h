//
//  WBReminderNoticeView.h
//  ROTARY COIMBATORE
//
//  Created by Mac 145 on 7/23/14.
//  Copyright (c) 2014 Angler. All rights reserved.
//

#import "WBNoticeView.h"

/**
 The `WBErrorNoticeView` class is a `WBNoticeView` subclass suitable for displaying an error to a user. The notice is presented on a red gradient background with an error icon on the left hand side of the notice. It supports the display of a title and a message.
 */
@interface WBReminderNoticeView : WBNoticeView

///-------------------------------
/// @name Creating an Reminder Notice
///-------------------------------

/**
 Creates and returns an error notice in the given view with the specified title and message.
 
 @param view The view to display the notice in.
 @param title The title of the notice.
 @param message The message of the notice.
 @return The newly created error notice object.
 */
+ (WBReminderNoticeView *)reminderNoticeInView:(UIView *)view title:(NSString *)title message:(NSString *)message;

@end
