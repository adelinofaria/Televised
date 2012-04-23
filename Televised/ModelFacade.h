//
//  ModelFacade.h
//  mySeries
//
//  Created by Adelino Faria on 11/22/11.
//  Copyright (c) 2011 Rabid Cat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCommandFile @"commandFile"
#define kSearchKey @"show"
#define kShowID @"sid"
#define kEpisodeID @"ep"

@class Show;
@class Episode;

@interface ModelFacade : NSObject

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (ModelFacade *)sharedInstance;

- (NSString *)makeRequest:(NSDictionary *)parameters;

- (NSData *)getImageFromURL:(NSString *)url;
- (NSMutableArray *)searchShow:(NSString *)searchToken;
- (Show *)getShowInfo:(NSString *)show;
- (Show *)getShowEpisodes:(NSString *)show;
- (Episode *)getEpisodeInfo:(NSString *)episode fromShow:(NSString *)show;

@end
