//
//  GOImageCache.h
//  GOImageCache
//
//  Created by Samuel Goodwin on 12/30/11.
//  Copyright (c) 2011 SNAP Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kImageQueueName;
extern NSString *const kImageCacheName;
extern const NSInteger kImageQueueConcurrencyCount;

typedef void (^GOImageBlock)(NSImage* image);

@interface GOImageCache : NSObject
@property (nonatomic, strong) NSOperationQueue *imageQueue;
@property (nonatomic, strong) NSCache *imageCache;

+ (id)sharedImageCache;
- (void)getImageWithURL:(NSURL*)url andCompletion:(GOImageBlock)imageBlock;
@end
