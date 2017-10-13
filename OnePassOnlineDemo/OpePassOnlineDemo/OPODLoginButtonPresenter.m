//
//  OPODLoginButtonPresenter.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 29.09.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPODLoginButtonPresenter.h"

@interface OPODLoginButtonPresenter()

@property (nonatomic) id<IOPODLoginButtonViewProtocol> loginView;

@end

@implementation OPODLoginButtonPresenter

- (void)attachView:(id<IOPODLoginButtonViewProtocol>)loginView {
    _loginView = loginView;
}

- (void)setStateBasedOnFullEnroll:(BOOL)isFullEnroll {
    if (isFullEnroll) {
        [self.loginView setSignIN];
    } else {
        [self.loginView setSignUP];
    }
}

- (void)setStateBasedOnPersonExists:(BOOL)isPersonExists {
    if (isPersonExists) {
        [self.loginView setSignUP];
    } else {
        [self.loginView setSignOFF];
    }
}

-(void)setStateBasedOnValidEmail:(BOOL)isValidEmail {
    if (isValidEmail) {
        [self.loginView setSignUP];
    } else {
        [self.loginView setSignOFF];
    }
}

-(void)setStateToOFF{
    [self.loginView setSignOFF];
}

@end
