//
//  OPUIEnrollAgreementViewProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OPUIEnrollAgreementViewProtocol <NSObject>

-(void)showWarnings:(NSArray *)source;

-(void)routeToFacePage;
-(void)routeToVoicePage;

-(void)exit;

@end
