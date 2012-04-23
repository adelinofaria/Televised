//
//  AppDelegate.h
//  mySeries
//
//  Created by Adelino Faria on 11/22/11.
//  Copyright (c) 2011 Rabid Cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestDelegate.h"

typedef enum
{
    HttpConnectionTypeGET,
    HttpConnectionTypePOST,
    HttpConnectionTypePUT,
    HttpConnectionTypeDELETE
} HttpConnectionType;


@interface HttpRequest : NSObject <NSURLConnectionDataDelegate>
{
    NSURL *url;
    HttpConnectionType type;
    NSDictionary *dictionary;
    id<HttpRequestDelegate> delegate;
    
    NSMutableData *responseData;
    NSURLConnection *urlConnection;
}

+ (NSData *)performSyncRequest:(NSString *)url requestType:(HttpConnectionType)type dictionary:(NSDictionary *)dictionary;
+ (void)performAsyncRequest:(NSString *)url requestType:(HttpConnectionType)type dictionary:(NSDictionary *)dictionary delegate:(id<HttpRequestDelegate>)delegate;
+ (void)performThreadedSyncRequest:(NSString *)url requestType:(HttpConnectionType)type dictionary:(NSDictionary *)dictionary delegate:(id<HttpRequestDelegate>)delegate;
+ (void)performThreadedAsyncRequest:(NSString *)url requestType:(HttpConnectionType)type dictionary:(NSDictionary *)dictionary delegate:(id<HttpRequestDelegate>)delegate;

@end
