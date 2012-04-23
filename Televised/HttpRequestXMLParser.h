//
//  HttpRequestXMLParser.h
//  mySeries
//
//  Created by Adelino Faria on 11/22/11.
//  Copyright (c) 2011 Rabid Cat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    XMLParserFileStructureSearch,
    XMLParserFileStructureShowInfo,
    XMLParserFileStructureEpisodeList,
    XMLParserFileStructureEpisodeInfo
} XMLParserFileStructure;

@interface HttpRequestXMLParser : NSObject <NSXMLParserDelegate> {
    NSString *capturedString;
    NSDictionary *requestInformation;
    NSDictionary *currentAttributeDictionary;
    NSMutableDictionary *newObjectsDictionary;
    XMLParserFileStructure structure;
}

- (id)parseXML:(NSData *)data fileStructure:(XMLParserFileStructure)fileStructure requestInfo:(NSDictionary *)requestInfo;

@end
