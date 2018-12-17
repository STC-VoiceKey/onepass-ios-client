//
//  OPUIVerifyFaceForStaticVoicePresenter.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 24.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyFaceForStaticVoicePresenter.h"
#import "OPUIVerifyAddFaceForStaticVoiceService.h"
#import "OPUIVerifyStaticVoiceWithFaceProtocol.h"

@interface OPUIVerifyFaceForStaticVoicePresenter()

@property (nonatomic) id<OPUIVerifyAddFaceForStaticVoiceServiceProtocol> addFaceService;
@property (nonatomic) BOOL isProgress;

@end

@implementation OPUIVerifyFaceForStaticVoicePresenter

- (void)attachView:(id<OPUIVerifyFaceViewProtocol>)view {
    [super attachView:view];
    
    self.addFaceService = [[OPUIVerifyAddFaceForStaticVoiceService alloc] init];
    
    [self.addFaceService setService:view.service];
    [self.addFaceService setUser:view.user];
    self.isProgress = NO;
}

-(void)processPhoto:(CIImage *)image {
    
    if (self.isProgress) {
        return;
    }
    
    self.isProgress = YES;
    [self stopPhotoManager];

    __weak typeof(self) weakself = self;
    [self.view showActivity];

    [self.addFaceService addPhoto:image
               withHandler:^(NSDictionary *result, NSError *error) {
                       [weakself.view hideActivity];
                       if (error) {
                           [weakself.view routeToPageWithError:error];
                           return ;
                       }
                        id<OPUIVerifyStaticVoiceWithFaceProtocol> staticFaceView = (id<OPUIVerifyStaticVoiceWithFaceProtocol>)weakself.view;
                        [staticFaceView routeToStaticVoicePage];
                   }];
}

@end
