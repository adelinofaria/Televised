//
//  ModelFacade.m
//  mySeries
//
//  Created by Adelino Faria on 11/22/11.
//  Copyright (c) 2011 Rabid Cat. All rights reserved.
//

#import "ModelFacade.h"
#import "HttpRequest.h"

@implementation ModelFacade

static ModelFacade *instance;

+ (ModelFacade *)sharedInstance
{
    if (!instance)
    {
        instance = [[ModelFacade alloc] init];
    }
    
    return instance;
}

+ (void)makeRequest
{
    //http://services.tvrage.com/myfeeds/showinfo.php?key=weHjGD4aOqY2JMoVPrby&sid=18388
    //http://services.tvrage.com/myfeeds/episode_list.php?key=weHjGD4aOqY2JMoVPrby&sid=18388
    //http://services.tvrage.com/myfeeds/episodeinfo.php?key=weHjGD4aOqY2JMoVPrby&sid=18388&ep=1x1
    [HttpRequest performSyncRequest:@"http://services.tvrage.com/myfeeds/showinfo.php?key=weHjGD4aOqY2JMoVPrby&sid=18388" requestType:GET dictionary:nil];
}

@end
