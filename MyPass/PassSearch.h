//
//  PassSearch.h
//  MyPass
//
//  Created by kevin on 01/09/15.
//  Copyright (c) 2015 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPassItem : NSObject

@property NSString *server;
@property NSString *account;

- (NSString*)getPassword;

@end

@interface MapContext : NSObject

@property NSString *server;
@property NSMutableArray *array;

@end


@interface PassSearch : NSObject

+ (void)printError:(OSStatus) status;
+ (NSArray*)searchItems:(NSString*) server;

@end
