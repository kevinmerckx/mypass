//
//  PassSearch.m
//  MyPass
//
//  Created by kevin on 01/09/15.
//  Copyright (c) 2015 kevin. All rights reserved.
//

#import "PassSearch.h"

@interface MyPassItem ()

@end

@implementation MyPassItem

- (NSString*)getPassword {
    const char *acct = nil, *srvr = nil;
    void *pw = 0;
    NSString *result = nil;
    
    @try {
        acct = [self.account UTF8String];
        srvr = [self.server UTF8String];
        
        UInt32 acctLen = (UInt32)strlen(acct);
        UInt32 srvrLen = (UInt32)strlen(srvr);
        
        UInt32 pwLen = 0;
        
        [PassSearch printError:SecKeychainFindInternetPassword(nil, srvrLen, srvr, 0, nil, acctLen, acct, 0, nil, 0, kSecProtocolTypeAny, kSecAuthenticationTypeAny, &pwLen, &pw, nil)];
        
        if (pw) {
            result = [NSString stringWithUTF8String:pw];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        if (pw) SecKeychainItemFreeContent(nil, pw);
    }
    
    return result;
}

@end

@implementation MapContext

@end

@implementation PassSearch

+ (void)printError:(OSStatus) status {
    void *r;
    NSLog(@"%@", SecCopyErrorMessageString(status, r));
}

+ (NSArray*)
searchItems:(NSString*) server {
    CFMutableDictionaryRef query = nil;
    CFArrayRef items = nil;
    MapContext *context = [[MapContext alloc] init];
    context.array = [[NSMutableArray alloc] init];
    context.server = server;

    @try {
        // create query
        query = CFDictionaryCreateMutable(kCFAllocatorDefault, 3, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        CFDictionaryAddValue(query, kSecReturnAttributes, kCFBooleanTrue);
        CFDictionaryAddValue(query, kSecMatchLimit, kSecMatchLimitAll);
        CFDictionaryAddValue(query, kSecClass, kSecClassInternetPassword);
        
        // get search results
        OSStatus status = SecItemCopyMatching(query, (CFTypeRef*)&items);
        assert(status == 0);
        
        // do something with the result
        CFRange range = CFRangeMake(0, CFArrayGetCount(items));
        
        CFArrayApplyFunction(items, range, addItem, (__bridge void*)context);
    }
    @catch (NSException *exception) {
    }
    @finally {
        if (query) CFRelease(query);
        if (items) CFRelease(items);
    }
    
    return context.array;
}

static void
addItem
(const void *value, void *_context) {
    CFDictionaryRef dict = value;
    MapContext *context = (__bridge MapContext *)_context;
    
    const char *acct = [(NSString *)(CFDictionaryGetValue(dict, kSecAttrAccount)) UTF8String];
    
    if (!acct) {
        return;
    }
    
    NSRange range = [(NSString*)(CFDictionaryGetValue(dict, kSecAttrServer)) rangeOfString:context.server];
    if (range.location == NSNotFound) {
        return;
    }
    
    MyPassItem *item = [[MyPassItem alloc] init];
    item.account = (NSString *)(CFDictionaryGetValue(dict, kSecAttrAccount));
    item.server = (NSString *)(CFDictionaryGetValue(dict, kSecAttrServer));
    
    [context.array addObject:item];
}

@end

