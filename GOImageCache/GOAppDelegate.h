//
//  GOAppDelegate.h
//  GOImageCache
//
//  Created by Samuel Goodwin on 12/30/11.
//

#import <Cocoa/Cocoa.h>

@interface GOAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (strong) NSOperationQueue *queue;
@property (strong) NSMutableArray *URLStrings;
@property (unsafe_unretained) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSView *flickerHider;
@property (weak) IBOutlet NSTableView *tableView;
@property (unsafe_unretained) IBOutlet NSTableCellView *dummyCell;
@end
