//
//  HttpRequestXMLParser.m
//  mySeries
//
//  Created by Adelino Faria on 11/22/11.
//  Copyright (c) 2011 Rabid Cat. All rights reserved.
//

#import "HttpRequestXMLParser.h"
#import "ModelFacade.h"
#import "Episode.h"
#import "Network.h"
#import "Season.h"
#import "Genre.h"
#import "Show.h"
#import "Aka.h"

#define kSearchResults @"SearchResults"
#define kShow @"Show"
#define kSeason @"Season"
#define kEpisode @"Episode"
#define kNetwork @"Network"
#define kGenre @"Genre"
#define kAka @"Aka"

@interface HttpRequestXMLParser (Private)

- (void)parseSearchDidStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict;
- (void)parseSearchDidEndElement:(NSString *)elementName;
- (void)parseShowInfoDidStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict;
- (void)parseShowInfoDidEndElement:(NSString *)elementName;
- (void)parseEpisodeListDidStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict;
- (void)parseEpisodeListDidEndElement:(NSString *)elementName;
- (void)parseEpisodeInfoDidStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict;
- (void)parseEpisodeInfoDidEndElement:(NSString *)elementName;

@end

@implementation HttpRequestXMLParser

- (id)parseXML:(NSData *)data fileStructure:(XMLParserFileStructure)fileStructure requestInfo:(NSDictionary *)requestInfo {
    self->structure = fileStructure;
    self->requestInformation = requestInfo;
    self->newObjectsDictionary = [[NSMutableDictionary alloc] init];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    parser.delegate = self;
    parser.shouldResolveExternalEntities = YES;
    
    if ([parser parse]) {
        if (self->structure == XMLParserFileStructureSearch)
            return [self->newObjectsDictionary objectForKey:kSearchResults];
        if (self->structure == XMLParserFileStructureShowInfo)
            return [self->newObjectsDictionary objectForKey:kShow];
        if (self->structure == XMLParserFileStructureEpisodeList)
            return [self->newObjectsDictionary objectForKey:kShow];
        if (self->structure == XMLParserFileStructureEpisodeInfo)
            return nil;
    }
    
    return nil;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    capturedString = nil;
    currentAttributeDictionary = attributeDict;
    
    if (self->structure == XMLParserFileStructureSearch)
        [self parseSearchDidStartElement:elementName attributes:attributeDict];
    if (self->structure == XMLParserFileStructureShowInfo)
        [self parseShowInfoDidStartElement:elementName attributes:attributeDict];
    if (self->structure == XMLParserFileStructureEpisodeList)
        [self parseEpisodeListDidStartElement:elementName attributes:attributeDict];
    if (self->structure == XMLParserFileStructureEpisodeInfo)
        [self parseEpisodeInfoDidStartElement:elementName attributes:attributeDict];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    capturedString = string;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (self->structure == XMLParserFileStructureSearch)
        [self parseSearchDidEndElement:elementName];
    if (self->structure == XMLParserFileStructureShowInfo)
        [self parseShowInfoDidEndElement:elementName];
    if (self->structure == XMLParserFileStructureEpisodeList)
        [self parseEpisodeListDidEndElement:elementName];
    if (self->structure == XMLParserFileStructureEpisodeInfo)
        [self parseEpisodeInfoDidEndElement:elementName];
}

#pragma mark - Segmented Methods
#pragma mark - Search

- (void)parseSearchDidStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"Results"])
        [self->newObjectsDictionary setObject:[[NSMutableArray alloc] init] forKey:kSearchResults];
}

- (void)parseSearchDidEndElement:(NSString *)elementName {
    if([elementName isEqualToString:@"showid"]) {
        NSManagedObjectContext *managedObjectContext = [ModelFacade sharedInstance].managedObjectContext;
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kShow inManagedObjectContext:managedObjectContext];
        
        Show *show = [[Show alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
        show.showid = [NSNumber numberWithInt:capturedString.intValue];
        
        [self->newObjectsDictionary setObject:show forKey:kShow];
        [(NSMutableArray *)[self->newObjectsDictionary objectForKey:kSearchResults] addObject:show];
    }
    if([elementName isEqualToString:@"name"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).name = capturedString;
    if([elementName isEqualToString:@"link"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).link = capturedString;
    if([elementName isEqualToString:@"country"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).country = capturedString;
    if([elementName isEqualToString:@"started"]) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"M/dd/yyyy"];
        
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).started = [format dateFromString:capturedString];
    }
    if([elementName isEqualToString:@"ended"]) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"M/dd/yyyy"];
        
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).ended = [format dateFromString:capturedString];
    }
    if([elementName isEqualToString:@"seasons"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).seasons = [NSNumber numberWithInt:capturedString.intValue];
    if([elementName isEqualToString:@"status"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).status = capturedString;
    if([elementName isEqualToString:@"classification"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).classification = capturedString;
    if([elementName isEqualToString:@"genre"]) {
        NSManagedObjectContext *managedObjectContext = [ModelFacade sharedInstance].managedObjectContext;
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kGenre inManagedObjectContext:managedObjectContext];
        
        Genre *genre = [[Genre alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
        genre.name = capturedString;
        
        [(Show *)[self->newObjectsDictionary objectForKey:kShow] addShow_genreObject:genre];
    }
}

#pragma mark - Show Info

- (void)parseShowInfoDidStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    
}

- (void)parseShowInfoDidEndElement:(NSString *)elementName {
    if([elementName isEqualToString:@"showid"]) {
        NSManagedObjectContext *managedObjectContext = [ModelFacade sharedInstance].managedObjectContext;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:kShow inManagedObjectContext:managedObjectContext];
        request.predicate = [NSPredicate predicateWithFormat:@"showid = %@", capturedString];
        
        Show *show = nil;
        NSError *error = nil;
        
        show = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
        
        if (!error && !show) {
            show = [NSEntityDescription insertNewObjectForEntityForName:kShow inManagedObjectContext:managedObjectContext];
            show.showid = [NSNumber numberWithInt:capturedString.intValue];
        }
        
        [self->newObjectsDictionary setObject:show forKey:kShow];
    }
    if([elementName isEqualToString:@"showname"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).name = capturedString;
    if([elementName isEqualToString:@"showlink"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).link = capturedString;
    if([elementName isEqualToString:@"seasons"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).seasons = [NSNumber numberWithInt:capturedString.intValue];
    if([elementName isEqualToString:@"image"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).image = [[ModelFacade sharedInstance] getImageFromURL:capturedString];
    if([elementName isEqualToString:@"startdate"]) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"M/dd/yyyy"];
        
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).started = [format dateFromString:capturedString];
    }
    if([elementName isEqualToString:@"ended"]) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"M/dd/yyyy"];
        
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).ended = [format dateFromString:capturedString];
    }
    if([elementName isEqualToString:@"origin_country"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).country = capturedString;
    if([elementName isEqualToString:@"status"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).status = capturedString;
    if([elementName isEqualToString:@"classification"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).classification = capturedString;
    if([elementName isEqualToString:@"genre"]) {
        NSManagedObjectContext *managedObjectContext = [ModelFacade sharedInstance].managedObjectContext;
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kGenre inManagedObjectContext:managedObjectContext];
        
        Genre *genre = [[Genre alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
        genre.name = capturedString;
        
        [(Show *)[self->newObjectsDictionary objectForKey:kShow] addShow_genreObject:genre];
    }
    if([elementName isEqualToString:@"runtime"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).runtime = [NSNumber numberWithInt:capturedString.intValue];
    if([elementName isEqualToString:@"network"]) {
        NSManagedObjectContext *managedObjectContext = [ModelFacade sharedInstance].managedObjectContext;
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kNetwork inManagedObjectContext:managedObjectContext];
        
        Network *network = [[Network alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
        network.name = capturedString;
        network.country = [currentAttributeDictionary objectForKey:@"country"];
        
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).show_network = network;
    }
    if([elementName isEqualToString:@"airday"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).airday = capturedString;
    if([elementName isEqualToString:@"timezone"]) {
        /* TODO TIMEZONE
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"z"];
        
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).started = [format dateFromString:capturedString];*/
    }
    if([elementName isEqualToString:@"aka"]) {
        NSManagedObjectContext *managedObjectContext = [ModelFacade sharedInstance].managedObjectContext;
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kAka inManagedObjectContext:managedObjectContext];
        
        Aka *aka = [[Aka alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
        aka.name = capturedString;
        aka.country = nil;
        
        [(Show *)[self->newObjectsDictionary objectForKey:kShow] addShow_akaObject:aka];
    }
}

#pragma mark - Episode List

- (void)parseEpisodeListDidStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    if([elementName isEqualToString:@"Show"]) {NSManagedObjectContext *managedObjectContext = [ModelFacade sharedInstance].managedObjectContext;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:kShow inManagedObjectContext:managedObjectContext];
        request.predicate = [NSPredicate predicateWithFormat:@"showid = %@", [self->requestInformation objectForKey:kShowID]];
        
        Show *show = nil;
        NSError *error = nil;
        
        show = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
        
        if (!error && !show) {
            show = [NSEntityDescription insertNewObjectForEntityForName:kShow inManagedObjectContext:managedObjectContext];
            show.showid = [NSNumber numberWithInt:capturedString.intValue];
        }
        
        [self->newObjectsDictionary setObject:show forKey:kShow];
    }
    if([elementName isEqualToString:@"Season"]) {
        NSManagedObjectContext *managedObjectContext = [ModelFacade sharedInstance].managedObjectContext;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:kSeason inManagedObjectContext:managedObjectContext];
        request.predicate = [NSPredicate predicateWithFormat:@"number = %@", [attributeDict objectForKey:@"no"]];
        
        Season *season = nil;
        NSError *error = nil;
        
        season = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
        
        if (!error && !season) {
            season = [NSEntityDescription insertNewObjectForEntityForName:kShow inManagedObjectContext:managedObjectContext];
            season.number = [attributeDict objectForKey:@"no"];
            [(Show *)[self->newObjectsDictionary objectForKey:kShow] addShow_seasonObject:season];
        }
        
        [self->newObjectsDictionary setObject:season forKey:kSeason];
    }
}

- (void)parseEpisodeListDidEndElement:(NSString *)elementName {
    if([elementName isEqualToString:@"name"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).name = capturedString;
    if([elementName isEqualToString:@"totalseasons"])
        ((Show *)[self->newObjectsDictionary objectForKey:kShow]).seasons = [NSNumber numberWithInt:capturedString.intValue];
    if ([elementName isEqualToString:@"epnum"]) {
        NSManagedObjectContext *managedObjectContext = [ModelFacade sharedInstance].managedObjectContext;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:kEpisode inManagedObjectContext:managedObjectContext];
        request.predicate = [NSPredicate predicateWithFormat:@"episodeid = %@", capturedString];
        
        Episode *episode = nil;
        NSError *error = nil;
        
        episode = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
        
        if (!error && !episode) {
            episode = [NSEntityDescription insertNewObjectForEntityForName:kShow inManagedObjectContext:managedObjectContext];
            episode.epnum = [NSNumber numberWithInt:capturedString.intValue];
            [(Season *)[self->newObjectsDictionary objectForKey:kSeason] addSeason_episodeObject:episode];
        }
        
        [self->newObjectsDictionary setObject:episode forKey:kEpisode];
    }
    if([elementName isEqualToString:@"seasonnum"])
        ((Episode *)[self->newObjectsDictionary objectForKey:kEpisode]).seasonnum = [NSNumber numberWithInt:capturedString.intValue];
    if([elementName isEqualToString:@"prodnum"])
        ((Episode *)[self->newObjectsDictionary objectForKey:kEpisode]).prodnum = [NSNumber numberWithInt:capturedString.intValue];
    if([elementName isEqualToString:@"airdate"]) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-mm-dd"];
        
        ((Episode *)[self->newObjectsDictionary objectForKey:kEpisode]).airdate = [format dateFromString:capturedString];
    }
    if([elementName isEqualToString:@"link"])
        ((Episode *)[self->newObjectsDictionary objectForKey:kEpisode]).link = capturedString;
    if([elementName isEqualToString:@"title"])
        ((Episode *)[self->newObjectsDictionary objectForKey:kEpisode]).title = capturedString;
    if([elementName isEqualToString:@"rating"])
        ((Episode *)[self->newObjectsDictionary objectForKey:kEpisode]).rating = [NSNumber numberWithInt:capturedString.intValue];
    if([elementName isEqualToString:@"screencap"])
        ((Episode *)[self->newObjectsDictionary objectForKey:kEpisode]).screencap = [[ModelFacade sharedInstance] getImageFromURL:capturedString];
    
}

#pragma mark - Episode Info

- (void)parseEpisodeInfoDidStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    if([elementName isEqualToString:@"show"]) {
        
    }
    if([elementName isEqualToString:@"episode"]) {
        
    }
}

- (void)parseEpisodeInfoDidEndElement:(NSString *)elementName {
    if([elementName isEqualToString:@"name"]) {
    }
    if([elementName isEqualToString:@"link"]) {
    }
    if([elementName isEqualToString:@"started"]) {
    }
    if([elementName isEqualToString:@"ended"]) {
    }
    if([elementName isEqualToString:@"country"]) {
    }
    if([elementName isEqualToString:@"status"]) {
    }
    if([elementName isEqualToString:@"classification"]) {
    }
    if([elementName isEqualToString:@"genre"]) {
    }
    if([elementName isEqualToString:@"airtime"]) {
    }
    if([elementName isEqualToString:@"runtime"]) {
    }
    if([elementName isEqualToString:@"runtime"]) {
    }
}

@end
