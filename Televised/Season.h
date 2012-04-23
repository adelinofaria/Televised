//
//  Season.h
//  Televised
//
//  Created by Adelino Faria on 4/19/12.
//  Copyright (c) 2012 Rabid Cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Episode, Show;

@interface Season : NSManagedObject

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSSet *season_episode;
@property (nonatomic, retain) Show *season_show;
@end

@interface Season (CoreDataGeneratedAccessors)

- (void)addSeason_episodeObject:(Episode *)value;
- (void)removeSeason_episodeObject:(Episode *)value;
- (void)addSeason_episode:(NSSet *)values;
- (void)removeSeason_episode:(NSSet *)values;

@end
