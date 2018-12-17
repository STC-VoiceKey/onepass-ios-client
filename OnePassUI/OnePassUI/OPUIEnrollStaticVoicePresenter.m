//
//  OPUIEnrollStaticVoicePresenter.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 01.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollStaticVoicePresenter.h"
#import "OPUIEnrollStaticVoiceViewProtocol.h"
#import "OPUIStaticEnrollVoiceService.h"
#import "OPUILoader.h"

@interface OPUIEnrollStaticVoicePresenter ()

@property (nonatomic) id<OPUIEnrollStaticVoiceViewProtocol> enrollView;

@property (nonatomic) NSUInteger sampleNumber;

@property (nonatomic) id<OPUIStaticVoiceServiceProtocol> staticVoiceService;

@end

@implementation OPUIEnrollStaticVoicePresenter

-(id)initWithVoiceManager:(id<IOPCCaptureVoiceManagerProtocol>)voiceManager
  withService:(id<IOPCTransportProtocol>)service {
    self = [super initWithVoiceManager:voiceManager withService:service];
    if (self) {
        self.staticVoiceService = [[OPUIStaticEnrollVoiceService alloc] init];
        [self.staticVoiceService setService:service];
    }
    return self;
}

- (void)attachView:(id<OPUIEnrollStaticVoiceViewProtocol>)view
    numberOfSample:(NSUInteger)sampleNumber {
    [super attachView:view];
    
    self.sampleNumber = sampleNumber;
    
    self.enrollView = (id<OPUIEnrollStaticVoiceViewProtocol>)self.view;
}

-(void)processVoice:(NSData *)data {
    __weak typeof(self) weakself = self;
    [weakself.staticVoiceService processVoice:data
                                  withHandler:^(NSDictionary *result, NSError *error) {
                           [weakself.view hideActivity];
                           if (error) {
                               [weakself.view showError:error];
                               return;
                           }
                           
                           if (self.sampleNumber != 3) {
                               [weakself.enrollView routeToNextVoice];
                           } else {
                               [OPUILoader.sharedInstance enrollResultBlock]( YES, nil);
                           }
                       }];
}

@end

