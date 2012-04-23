//
//  ModelFacade.m
//  mySeries
//
//  Created by Adelino Faria on 11/22/11.
//  Copyright (c) 2011 Rabid Cat. All rights reserved.
//

#import "ModelFacade.h"
#import "HttpRequestXMLParser.h"
#import "HttpRequest.h"
#import "Episode.h"
#import "Show.h"

#define kSearch @"search.php"
#define kShowInfoFile @"showinfo.php"
#define kEpisodeListFile @"episode_list.php"
#define kEpisodeInfoFile @"episodeinfo.php"
#define kFullSchedule @"fullschedule.php"
#define kCountDown @"countdown.php"
#define kCurrentShows @"currentshows.php"

#define apiKey @"weHjGD4aOqY2JMoVPrby"
#define apiKeyPair @"key=weHjGD4aOqY2JMoVPrby"
#define baseURL @"http://services.tvrage.com/myfeeds/"

@interface ModelFacade (Private)

+ (NSString *)makeRequest:(NSString *)commandFile;

@end

@implementation ModelFacade

@synthesize managedObjectContext = _managedObjectContext;

static ModelFacade *instance;

+ (ModelFacade *)sharedInstance {
    if (!instance)
        instance = [[ModelFacade alloc] init];
    
    return instance;
}

- (NSString *)makeRequest:(NSDictionary *)parameters {
    NSString *composedURL = [NSString stringWithFormat:@"%@%@?%@", baseURL, [parameters objectForKey:kCommandFile], apiKeyPair];
    
    for(NSString *key in parameters) {
        if (![key isEqualToString:kCommandFile]) {
            composedURL = [NSString stringWithFormat:@"%@&%@=%@", composedURL, key, [parameters valueForKey:key]];
        }
    }
    
    return composedURL;
}

- (NSData *)getImageFromURL:(NSString *)url {
    return [HttpRequest performSyncRequest:url requestType:HttpConnectionTypeGET dictionary:nil];
}

- (NSMutableArray *)searchShow:(NSString *)searchToken {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:kSearch, kCommandFile, searchToken, kSearchKey, nil];
    
    NSData *data = [HttpRequest performSyncRequest:[self makeRequest:parameters] requestType:HttpConnectionTypeGET dictionary:nil];
    
    NSMutableArray *object = [[[HttpRequestXMLParser alloc] init] parseXML:data fileStructure:XMLParserFileStructureSearch requestInfo:parameters];
    
    return object;
}

- (Show *)getShowInfo:(NSString *)show {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:kShowInfoFile, kCommandFile, show, kShowID, nil];
    
    NSData *data = [HttpRequest performSyncRequest:[self makeRequest:parameters] requestType:HttpConnectionTypeGET dictionary:nil];
    
    Show *object = [[[HttpRequestXMLParser alloc] init] parseXML:data fileStructure:XMLParserFileStructureShowInfo requestInfo:parameters];
    
    return object;
}

- (Show *)getShowEpisodes:(NSString *)show {
    //http://services.tvrage.com/myfeeds/episode_list.php?key=weHjGD4aOqY2JMoVPrby&sid=18388
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:kEpisodeListFile, kCommandFile, show, kShowID, nil];
    
    NSData *data = [HttpRequest performSyncRequest:[self makeRequest:parameters] requestType:HttpConnectionTypeGET dictionary:nil];
    
    Show *object = [[[HttpRequestXMLParser alloc] init] parseXML:data fileStructure:XMLParserFileStructureEpisodeList requestInfo:parameters];
    
    return object;
}

- (Episode *)getEpisodeInfo:(NSString *)episode fromShow:(NSString *)show {
    //http://services.tvrage.com/myfeeds/episodeinfo.php?key=weHjGD4aOqY2JMoVPrby&sid=18388&ep=1x1
    [HttpRequest performSyncRequest:@"http://services.tvrage.com/myfeeds/episode_list.php?key=weHjGD4aOqY2JMoVPrby&sid=18388" requestType:HttpConnectionTypeGET dictionary:nil];
    return nil;
}

@end
