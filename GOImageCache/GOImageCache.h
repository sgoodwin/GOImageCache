//
//  GOImageCache.h
//  GOImageCache
//
//  Created by Samuel Goodwin on 12/30/11.
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
