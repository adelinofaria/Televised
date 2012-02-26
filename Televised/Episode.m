//
//  Episode.m
//  Televised
//
//  Created by Adelino Faria on 2/24/12.
//  Copyright (c) 2012 Rabid Cat. All rights reserved.
//

#import "Episode.h"


@implementation Episode

@dynamic episodeid;
@dynamic seasonid;
@dynamic prodnum;
@dynamic airdate;
@dynamic link;
@dynamic title;
@dynamic rating;
@dynamic screencap;
@dynamic episode_show;

- (id)parseXML:(NSData *)data
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    parser.delegate = self;
    parser.shouldResolveExternalEntities = YES;
    
    if ([parser parse])
    {
        return data;
    }
    else
        return data;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"episode"])
    {
        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"episode"])
    {
        
    }
}

@end
