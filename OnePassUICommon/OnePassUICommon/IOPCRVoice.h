//
//  IOPCRVoice.h
//  OnePassUICommon
//
//  Created by Soloshcheva Aleksandra on 09.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IOPCRVoice <NSObject>
@required
-(void)setPassphraseNumber:(NSNumber *)number;
@end
