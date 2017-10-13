//
//  OPUITextView.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 04.10.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The custom text field with the ability to display the validation warning
 */
@interface OPUITextView : UITextView

/**
 Sets control in the invalid state and displays the cause of invalidation
 
 @param warning The invalid message
 */
-(void)showValidationMessage:(NSString *)warning;

/**
 Hides the validation message
 */
-(void)hideValidationMessage;

@end
