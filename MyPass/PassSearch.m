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
    const char *acct = [self.account UTF8String];
    const char *srvr = [self.server UTF8String];
    
    UInt32 acctLen = (UInt32)strlen(acct);
    UInt32 srvrLen = (UInt32)strlen(srvr);
    
    UInt32 pwLen = 0;
    void *pw = 0;
    
    [PassSearch printError:SecKeychainFindInternetPassword(nil, srvrLen, srvr, 0, nil, acctLen, acct, 0, nil, 0, kSecProtocolTypeAny, kSecAuthenticationTypeAny, &pwLen, &pw, nil)];
    
    CFStringRef pwString = CFStringCreateWithBytes(kCFAllocatorDefault, pw, pwLen, kCFStringEncodingUTF8, NO);
        
    if (!pw) {
        return nil;
    }
    NSString *password = [NSString stringWithUTF8String:pw];
    
    SecKeychainItemFreeContent(nil, pw);
    
    CFRelease(pwString);
    
    return password;
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
    
    // create query
    CFMutableDictionaryRef query = CFDictionaryCreateMutable(kCFAllocatorDefault, 3, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionaryAddValue(query, kSecReturnAttributes, kCFBooleanTrue);
    CFDictionaryAddValue(query, kSecMatchLimit, kSecMatchLimitAll);
    CFDictionaryAddValue(query, kSecClass, kSecClassInternetPassword);
    
    // get search results
    CFArrayRef result = nil;
    OSStatus status = SecItemCopyMatching(query, (CFTypeRef*)&result);
    assert(status == 0);
    
    MapContext *context = [[MapContext alloc] init];
    context.array = [[NSMutableArray alloc] init];
    context.server = server;
    
    // do something with the result
    CFRange range = CFRangeMake(0, CFArrayGetCount(result));
    
    CFArrayApplyFunction(result, range, addItem, (__bridge void*)context);
    
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

