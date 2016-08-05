//
//  OPUIBaseViewController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 21.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OnePassCore/OnePassCore.h>

@interface OPUIBaseViewController : UIViewController<ITransportService>

@property (nonatomic,weak) id<ITransport> service;

@property (nonatomic,readonly) NSString *userID;

-(void)applicationDidEnterBackground;

-(void)startActivityAnimating;
-(void)stopActivityAnimating;

-(void)performSegueOnMainThreadWithIdentifier:(NSString *)identifier;
-(void)showErrorOnMainThread:(NSError *)error;

@end
