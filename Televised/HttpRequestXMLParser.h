//
//  HttpRequestXMLParser.h
//  mySeries
//
//  Created by Adelino Faria on 11/22/11.
//  Copyright (c) 2011 Rabid Cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequestXMLParser : NSObject <NSXMLParserDelegate>
{
    NSString *capturedString;
}

- (id)parseXML:(NSData *)data;

@end
