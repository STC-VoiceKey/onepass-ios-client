//
//  OPCOPerson.h
//  OnePassCoreOnline
//
//  Created by Soloshcheva Aleksandra on 15.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/IPerson.h>
#import <OnePassCore/IModel.h>

@interface OPCOPerson : NSObject<IPerson>

-(id)initWithJSON:(NSDictionary *)json;

@property (nonatomic) NSString *userID;

@property (nonatomic) BOOL isFullEnroll;

@property (nonatomic) NSArray<IModel> *model;
/*-(NSString *)userID;
 -(BOOL)isFullEnroll;
 -(NSArray<IModel> *)model;*/
@end
