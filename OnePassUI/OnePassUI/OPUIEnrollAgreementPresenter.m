//
//  OPUIEnrollAgreementPresenter.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 09.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollAgreementPresenter.h"
#import "OPUIEnrollAgreementViewProtocol.h"
#import "OPUIModalitiesManager.h"

@interface OPUIEnrollAgreementPresenter()

@property (nonatomic) id<OPUIEnrollAgreementViewProtocol> view;
@property (nonatomic) id<IOPUIModalitiesManagerProtocol>  modalities;

@end

@interface OPUIEnrollAgreementPresenter(Private)

-(NSArray<NSDictionary*>*)dataSource;

@end

@implementation OPUIEnrollAgreementPresenter

- (void)attachView:(id<OPUIEnrollAgreementViewProtocol>)view {
    self.view = view;
    
    self.modalities = [[OPUIModalitiesManager alloc] init];
   
    [self.view showWarnings:self.dataSource];
}

- (void)deattachView {
    self.view = nil;
}

-(void)onContinue {
    if (self.modalities.isFaceOn) {
        [self.view routeToFacePage];
    } else {
        [self.view routeToVoicePage];
    }
}

-(void)onCancel {
    [self.view exit];
}

@end

@implementation OPUIEnrollAgreementPresenter(Private)

-(NSArray<NSDictionary*>*)dataSource {
    return @[@{ @"image":@"light",        @"cause":@"Find a well lit place"},
             @{ @"image":@"silence",      @"cause":@"Make sure it's quiet"},
             @{ @"image":@"eyesnotfound", @"cause":@"Take off sunglasses"},
             @{ @"image":@"face",         @"cause":@"Make your ordinary face"}];
}

@end
