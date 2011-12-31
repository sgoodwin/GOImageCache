//
//  GOAppDelegate.m
//  GOImageCache
//
//  Created by Samuel Goodwin on 12/30/11.
//  Copyright (c) 2011 SNAP Interactive. All rights reserved.
//

#import "GOAppDelegate.h"
#import "GOImageCache.h"
#import "GOHTTPOperation.h"

@interface GOAppDelegate()
- (void)getImageURLSFromIDs:(NSArray *)ids;
@end

@implementation GOAppDelegate

@synthesize queue = _queue;
@synthesize URLStrings = _URLStrings;
@synthesize window = _window;
@synthesize tableView = _tableView;
@synthesize dummyCell = _dummyCell;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.URLStrings = [NSMutableArray array];
    NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=bd080f67fef14278a481dac6257cb58f"];
    GOHTTPOperation *operation = [GOHTTPOperation operationWithURL:url method:GOHTTPMethodGET];
    GODataBlock block = ^(NSData *data){
        if(!data){
            return;
        }
        NSError *error = nil;
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if(!results){
            NSLog(@"Error reading JSON Response: %@", [error localizedDescription]);
        }
        
        NSArray *ids = [[results objectForKey:@"data"] valueForKey:@"id"];
        [self getImageURLSFromIDs:ids];
    };
    [operation addCompletion:block];
    [[NSOperationQueue mainQueue] addOperation:operation];
}

- (void)getImageURLSFromIDs:(NSArray *)ids{
    [ids enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@?client_id=bd080f67fef14278a481dac6257cb58f", obj];
        NSURL *url = [NSURL URLWithString:urlString];
        GOHTTPOperation *operation = [GOHTTPOperation operationWithURL:url method:GOHTTPMethodGET];
        [operation addCompletion:^(NSData *data){
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            [self.URLStrings addObject:[[[[response objectForKey:@"data"] objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"]];
            [self.tableView reloadData];
        }];
        [[NSOperationQueue mainQueue] addOperation:operation];
    }];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [self.URLStrings count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    static NSString *identifier = @"blahblahblah";
    NSTableCellView *cell = [tableView makeViewWithIdentifier:identifier owner:self];
    if(!cell){
        [NSBundle loadNibNamed:@"GODummyView" owner:self];
        cell = self.dummyCell;
        self.dummyCell = nil;
    }
    
    [cell.textField setStringValue:@""];
    
    NSString *string = [self.URLStrings objectAtIndex:row];
    NSURL *url = [NSURL URLWithString:string];
    [[GOImageCache sharedImageCache] getImageWithURL:url andCompletion:^(NSImage *image){
        NSTableCellView *acell = [tableView viewAtColumn:0 row:row makeIfNecessary:NO];
        if(acell){
            [acell.imageView setImage:image];
        }
    }];
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 612.0f;
}

@end
