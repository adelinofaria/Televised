//
//  Show.h
//  Televised
//
//  Created by Adelino Faria on 2/24/12.
//  Copyright (c) 2012 Rabid Cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Episode;

@interface Show : NSManagedObject <NSXMLParserDelegate>

@property (nonatomic, retain) NSNumber * showid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * seasons;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSDate * started;
@property (nonatomic, retain) NSDate * ended;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * classification;
@property (nonatomic, retain) NSNumber * runtime;
@property (nonatomic, retain) NSString * network;
@property (nonatomic, retain) NSDate * airtime;
@property (nonatomic, retain) NSSet *show_genere;
@property (nonatomic, retain) NSSet *show_aka;
@property (nonatomic, retain) NSSet *show_episode;
@end

@interface Show (CoreDataGeneratedAccessors)

- (void)addShow_genereObject:(NSManagedObject *)value;
- (void)removeShow_genereObject:(NSManagedObject *)value;
- (void)addShow_genere:(NSSet *)values;
- (void)removeShow_genere:(NSSet *)values;

- (void)addShow_akaObject:(NSManagedObject *)value;
- (void)removeShow_akaObject:(NSManagedObject *)value;
- (void)addShow_aka:(NSSet *)values;
- (void)removeShow_aka:(NSSet *)values;

- (void)addShow_episodeObject:(Episode *)value;
- (void)removeShow_episodeObject:(Episode *)value;
- (void)addShow_episode:(NSSet *)values;
- (void)removeShow_episode:(NSSet *)values;

@end
