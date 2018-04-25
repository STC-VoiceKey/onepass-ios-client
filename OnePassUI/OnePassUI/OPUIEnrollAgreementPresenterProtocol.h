//
//  OPUIEnrollAgreementPresenterProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPUIEnrollAgreementViewProtocol.h"

@protocol OPUIEnrollAgreementPresenterProtocol <NSObject>

-(void)attachView:(id<OPUIEnrollAgreementViewProtocol>)view;
-(void)deattachView;

-(void)onContinue;
-(void)onCancel;

@end
