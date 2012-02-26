//
//  HttpRequestDelegate.h
//  mySeries
//
//  Created by Adelino Faria on 11/22/11.
//  Copyright (c) 2011 Rabid Cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpRequestDelegate <NSObject>

- (void)requestReturn:(NSDictionary *)result fromRequest:(NSDictionary *)request;

@end
