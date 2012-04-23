//
//  Show.h
//  Televised
//
//  Created by Adelino Faria on 4/19/12.
//  Copyright (c) 2012 Rabid Cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Aka, Genre, Network, Season;

@interface Show : NSManagedObject

@property (nonatomic, retain) NSString * airday;
@property (nonatomic, retain) NSString * classification;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSDate * ended;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * runtime;
@property (nonatomic, retain) NSNumber * seasons;
@property (nonatomic, retain) NSNumber * showid;
@property (nonatomic, retain) NSDate * started;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSSet *show_aka;
@property (nonatomic, retain) NSSet *show_genre;
@property (nonatomic, retain) Network *show_network;
@property (nonatomic, retain) NSSet *show_season;
@end

@interface Show (CoreDataGeneratedAccessors)

- (void)addShow_akaObject:(Aka *)value;
- (void)removeShow_akaObject:(Aka *)value;
- (void)addShow_aka:(NSSet *)values;
- (void)removeShow_aka:(NSSet *)values;

- (void)addShow_genreObject:(Genre *)value;
- (void)removeShow_genreObject:(Genre *)value;
- (void)addShow_genre:(NSSet *)values;
- (void)removeShow_genre:(NSSet *)values;

- (void)addShow_seasonObject:(Season *)value;
- (void)removeShow_seasonObject:(Season *)value;
- (void)addShow_season:(NSSet *)values;
- (void)removeShow_season:(NSSet *)values;

@end
