//
//  ViewController.h
//  MyPass
//
//  Created by kevin on 01/09/15.
//  Copyright (c) 2015 kevin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>

@property (weak) IBOutlet NSSearchFieldCell *searchFieldCell;
@property (weak) IBOutlet NSTableView *resultsTableView;
@property (strong, nonatomic) NSArray *results;

@end

