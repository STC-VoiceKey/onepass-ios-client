//
//  IVerifySession.h
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 24.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IVerifySession <NSObject>
@required
-(NSString *)verificationSessionID;
-(NSString *)passphrase;
@end
