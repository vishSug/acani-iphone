//
//  Account.h
//  Lovers
//
//  Created by Matt Di Pasquale on 10/31/10.
//  Copyright 2010 Diamond Dynasties, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class User;

@interface Account :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) User * user;

@end



