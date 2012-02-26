//
//  Episode.h
//  Televised
//
//  Created by Adelino Faria on 2/24/12.
//  Copyright (c) 2012 Rabid Cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Episode : NSManagedObject <NSXMLParserDelegate>

@property (nonatomic, retain) NSNumber * episodeid;
@property (nonatomic, retain) NSNumber * seasonid;
@property (nonatomic, retain) NSString * prodnum;
@property (nonatomic, retain) NSDate * airdate;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSData * screencap;
@property (nonatomic, retain) NSManagedObject *episode_show;

@end
