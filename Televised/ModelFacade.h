//
//  ModelFacade.h
//  mySeries
//
//  Created by Adelino Faria on 11/22/11.
//  Copyright (c) 2011 Rabid Cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelFacade : NSObject

+ (ModelFacade *)sharedInstance;

+ (void)makeRequest;

@end
