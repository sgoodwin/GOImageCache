//
//  GOImageCache.m
//  GOImageCache
//
//  Created by Samuel Goodwin on 12/30/11.
//

#import "GOImageCache.h"
#import "GOHTTPOperation.h"

NSString *const kImageQueueName = @"com.goodwinlabs.imageQueue";
NSString *const kImageCacheName = @"com.goodwinlabs.imageCache";
const NSInteger kImageQueueConcurrencyCount = 3;

@interface GOImageCache()
- (GOHTTPOperation*)operationForURL:(NSURL*)url;
@end

@implementation GOImageCache
@synthesize imageQueue = _imageQueue;
@synthesize imageCache = _imageCache;

static GOImageCache *sharedImageCache = nil;
+ (id)sharedImageCache{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedImageCache = [[self alloc] init];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:kImageQueueConcurrencyCount];
        [queue setName:kImageQueueName];
        sharedImageCache.imageQueue = queue;
        
        NSCache *cache = [[NSCache alloc] init];
        [cache setName:kImageCacheName];
        sharedImageCache.imageCache = cache;
    });
    return sharedImageCache;
}

- (GOHTTPOperation*)operationForURL:(NSURL*)url{
    __block GOHTTPOperation *operation = nil;
    [[[self imageQueue] operations] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        if([[[obj request] URL] isEqual:url]){
            operation = obj;
            *stop = YES;
        }
    }];
    return operation;
}

- (void)getImageWithURL:(NSURL*)url andCompletion:(GOImageBlock)imageBlock{
    NSImage *image = [[self imageCache] objectForKey:url];
    if(image){
        dispatch_async(dispatch_get_main_queue(), ^{
            imageBlock(image);
        });
        return;
    }
    
    GODataBlock dataBlock = ^(NSData *data){
        NSImage *newImage = [[NSImage alloc] initWithData:data];
        if(!newImage){
            NSLog(@"Response when we wanted an image: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
        [[self imageCache] setObject:newImage forKey:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageBlock(newImage);
        });
    };
    
    GOHTTPOperation *operation = [self operationForURL:url];
    if(operation){
        [operation addCompletion:dataBlock];
        return;
    }
    
    operation = [GOHTTPOperation operationWithURL:url method:GOHTTPMethodGET];
    [operation addCompletion:dataBlock];
    [[self imageQueue] addOperation:operation];
}

@end
