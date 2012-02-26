//
//  DetailViewController.h
//  Televised
//
//  Created by Adelino Faria on 2/24/12.
//  Copyright (c) 2012 Rabid Cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
