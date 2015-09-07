//
//  AppDelegate.m
//  MyPass
//
//  Created by kevin on 01/09/15.
//  Copyright (c) 2015 kevin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:notification.name object:self];
}

@end
