//
//  ViewController.m
//  MyPass
//
//  Created by kevin on 01/09/15.
//  Copyright (c) 2015 kevin. All rights reserved.
//

#import "ViewController.h"
#import "PassSearch.h"

@import AppKit;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.results = [[NSArray alloc] init];
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

// NSTableViewDataSource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.results.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return ((MyPassItem*)(self.results[row]));
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    NSTableCellView *result = [tableView makeViewWithIdentifier:@"PassItemView" owner:self];
    ((NSTextField*)[result viewWithTag:0]).stringValue = ((MyPassItem*)(self.results[row])).account;
    ((NSTextField*)[result viewWithTag:1]).stringValue = ((MyPassItem*)(self.results[row])).server;
    
    // Return the result
    return result;
    
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    return YES;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    if (self.resultsTableView.selectedRow < 0) {
        return;
    }
    
    MyPassItem *item = self.results[self.resultsTableView.selectedRow];

    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setData:[[item getPassword] dataUsingEncoding:NSUTF8StringEncoding] forType:NSPasteboardTypeString];
}

// NSTextFieldDelegate methods

- (void)controlTextDidChange:(NSNotification *)obj {
    NSString *searchText = self.searchFieldCell.stringValue;
    NSLog(@"end, %@", searchText);
    self.results = [PassSearch searchItems:searchText];
    [self.resultsTableView reloadData];
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    return YES;
}
@end
