//
//  Episode.h
//  Televised
//
//  Created by Adelino Faria on 4/19/12.
//  Copyright (c) 2012 Rabid Cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Season;

@interface Episode : NSManagedObject

@property (nonatomic, retain) NSDate * airdate;
@property (nonatomic, retain) NSNumber * epnum;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * prodnum;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSData * screencap;
@property (nonatomic, retain) NSNumber * seasonnum;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) Season *episode_season;

@end
