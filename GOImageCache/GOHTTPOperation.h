//
//  GOHTTPOperation.h
//  GOImageCache
//
//  Created by Samuel Goodwin on 12/30/11.
//  Copyright (c) 2011 SNAP Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    GOHTTPMethodGET,
    GOHTTPMethodPOST
}GOHTTPMethod;

typedef void (^GODataBlock)(NSData* data);

@interface GOHTTPOperation : NSOperation<NSURLConnectionDelegate>
@property (assign, getter=isExecuting) BOOL executing;
@property (assign, getter=isFinished) BOOL finished;
@property (strong) NSMutableData *data;

@property (retain) NSMutableArray *completions;
@property (strong) NSURLRequest *request;

+ (id)operationWithURL:(NSURL*)url method:(GOHTTPMethod)method;
- (void)addCompletion:(GODataBlock)block;
@end
