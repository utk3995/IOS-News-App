//
//  NewsTableViewCell.h
//  MyStore
//
//  Created by utkarsh.sri on 05/09/18.
//  Copyright © 2018 utkarsh.sri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *publishedDate;

@end
