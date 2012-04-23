//
//  Network.h
//  Televised
//
//  Created by Adelino Faria on 4/19/12.
//  Copyright (c) 2012 Rabid Cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Show;

@interface Network : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) Show *network_show;

@end
