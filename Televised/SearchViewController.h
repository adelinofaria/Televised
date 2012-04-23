//
//  SearchViewController.h
//  Televised
//
//  Created by Adelino Faria on 4/20/12.
//  Copyright (c) 2012 Rabid Cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UITableViewController

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) NSMutableArray *searchResults;

@end
