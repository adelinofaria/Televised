//
//  AppDelegate.h
//  mySeries
//
//  Created by Adelino Faria on 11/22/11.
//  Copyright (c) 2011 Rabid Cat. All rights reserved.
//

#import "HttpRequest.h"
#import "HttpRequestXMLParser.h"


static BOOL debug = YES;

@implementation HttpRequest

- (HttpRequest *)initWithURL:(NSURL *)_url requestType:(HttpConnectionType)_type dictionary:(NSDictionary *)_dictionary delegate:(id)_delegate
{
    if ((self = [super init]))
    {
        url = _url;
        type = _type;
        dictionary = _dictionary;
        delegate = _delegate;
    }
    
    return self;
}

#pragma mark - UIWindow Network Activity Indicator

+ (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible
{
    static NSInteger NumberOfCallsToSetVisible = 0;
    
    if (setVisible)
        NumberOfCallsToSetVisible++;
    else 
        NumberOfCallsToSetVisible--;
    
    // The assertion helps to find programmer errors in activity indicator management.
    // Since a negative NumberOfCallsToSetVisible is not a fatal error, 
    // it should probably be removed from production code.
    NSAssert(NumberOfCallsToSetVisible >= 0, @"Network Activity Indicator was asked to hide more often than shown");
    
    // Display the indicator as long as our static counter is > 0.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(NumberOfCallsToSetVisible > 0)];
}

#pragma mark - Private Methods

- (NSMutableURLRequest *)requestSetup
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *bodyData;
    BOOL first = YES;
    
    switch (type)
    {
        case GET:
            [request setHTTPMethod:@"GET"];
            break;
        case POST:
            [request setHTTPMethod:@"POST"];
            break;
        case PUT:
            [request setHTTPMethod:@"PUT"];
            break;
        case DELETE:
            [request setHTTPMethod:@"DELETE"];
            break;
            
        default:
            break;
    }
    
    if (dictionary)
    {
        for(NSString *key in dictionary)
        {
            NSString *value = [dictionary valueForKey:key];
            
            if (first)
            {
                bodyData = [NSString stringWithFormat:@"%@=%@", key, value];
                first = NO;
            }
            else
                bodyData = [bodyData stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, value]];
        }
        
        [request setHTTPBody:[bodyData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    }
    
    return request;
}

- (void)performAsyncRequest
{
    NSMutableURLRequest *request = [self requestSetup];
    responseData = [NSMutableData data];
    
    [HttpRequest setNetworkActivityIndicatorVisible:YES];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (NSData *)performSyncRequest
{
    NSMutableURLRequest *request = [self requestSetup];
    NSURLResponse *response;
    NSError *error;
    
    [HttpRequest setNetworkActivityIndicatorVisible:YES];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    [HttpRequest setNetworkActivityIndicatorVisible:NO];
    
    return returnData;
}

- (id)requestDecode:(NSData *)result
{
    return [[[HttpRequestXMLParser alloc] init] parseXML:result];
}

- (void)requestReturn:(id<HttpRequestDelegate>)delegate result:(NSData *)result fromRequest:(NSDictionary *)dictionary
{
    if (debug)
        NSLog(@"%@", [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding]);
    
    static BOOL didNoticeNoConnection = FALSE;
    
    if ([result isKindOfClass:[NSString class]])
    {
        if ([(NSString *)result hasPrefix:@"Connection failed:"] && !didNoticeNoConnection)
        {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error_no_connection_title", @"") message:NSLocalizedString(@"error_no_connection", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil] show];
            didNoticeNoConnection = TRUE;
        }
    }
    else
        didNoticeNoConnection = FALSE;
    
    [self->delegate requestReturn:[self requestDecode:result] fromRequest:self->dictionary];
}

- (void)syncRequestThread:(HttpRequest *)request
{
    NSData *data = [request performSyncRequest];
    [self requestReturn:delegate result:data fromRequest:dictionary];
}

- (void)asyncRequestThread:(HttpRequest *)request
{
    [request performAsyncRequest];
}

#pragma mark - NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self requestReturn:delegate result:[NSString stringWithFormat:@"/n***Connection ERROR***/nConnection failed: %@/n***Connection ERROR***/n", [error description]] fromRequest:dictionary];
    
    [HttpRequest setNetworkActivityIndicatorVisible:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[HttpRequest setNetworkActivityIndicatorVisible:NO];
    
    [self requestReturn:delegate result:responseData fromRequest:dictionary];
}

#pragma mark - Public Methods

+ (NSData *)performSyncRequest:(NSString *)url requestType:(HttpConnectionType)type dictionary:(NSDictionary *)dictionary
{
    HttpRequest *request = [[HttpRequest alloc] initWithURL:[NSURL URLWithString:url] requestType:type dictionary:dictionary delegate:nil];
    
    NSData *result = [request performSyncRequest];
    
    if (debug)
        NSLog(@"%@", [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding]);
    
    return [request requestDecode:result];
}

+ (void)performAsyncRequest:(NSString *)url requestType:(HttpConnectionType)type dictionary:(NSDictionary *)dictionary delegate:(id<HttpRequestDelegate>)delegate
{
    HttpRequest *request = [[HttpRequest alloc] initWithURL:[NSURL URLWithString:url] requestType:type dictionary:dictionary delegate:delegate];
    
    [request performAsyncRequest];
}

+ (void)performThreadedSyncRequest:(NSString *)url requestType:(HttpConnectionType)type dictionary:(NSDictionary *)dictionary delegate:(id<HttpRequestDelegate>)delegate
{
    HttpRequest *request = [[HttpRequest alloc] initWithURL:[NSURL URLWithString:url] requestType:type dictionary:dictionary delegate:delegate];
    
    [NSThread detachNewThreadSelector:@selector(syncRequestThread:) toTarget:request withObject:nil];
}

+ (void)performThreadedAsyncRequest:(NSString *)url requestType:(HttpConnectionType)type dictionary:(NSDictionary *)dictionary delegate:(id<HttpRequestDelegate>)delegate
{
    HttpRequest *request = [[HttpRequest alloc] initWithURL:[NSURL URLWithString:url] requestType:type dictionary:dictionary delegate:delegate];
    
    [NSThread detachNewThreadSelector:@selector(asyncRequestThread:) toTarget:request withObject:nil];
}

@end
