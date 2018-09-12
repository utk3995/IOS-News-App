//
//  NewsTableView.m
//  MyStore
//
//  Created by utkarsh.sri on 04/09/18.
//  Copyright © 2018 utkarsh.sri. All rights reserved.
//

#import "NewsTableView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+WebCache.h>
#import "NewsTableViewCell.h"

@implementation NewsTableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

//To disselect the tableview cell already selected when the table view reappears.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.newsArray count];
}

- (NewsTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"newsCell";
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *newsItem = self.newsArray[indexPath.row];
    
    cell.newsTitle.text = [NSString stringWithFormat:@"%@",newsItem[@"title"]];
    cell.newsTitle.font = [UIFont fontWithName:@"Arial" size:15];
    cell.publishedDate.text = [self getPublishedDateInCorrectFormat: [NSString stringWithFormat:@"%@",newsItem[@"publishedAt"]]];
    cell.publishedDate.font = [UIFont fontWithName:@"Arial" size:12];
    
    NSURL *imageURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@",newsItem[@"urlToImage"]]];
    [cell.newsImage sd_setImageWithURL: imageURL placeholderImage: [UIImage imageNamed:@"no_image"]];
    
    return cell;
}

- (NSString *) getPublishedDateInCorrectFormat:(NSString *)originalDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *date  = [dateFormatter dateFromString:originalDate];
    
    // Convert to new Date Format
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

- (void) setNewsArray:(NSArray *)newsArray {
    _newsArray = newsArray;
    [self reloadData];
}

- (UIImage *) getNewsCellImage: (NSDictionary *)newsItem {
    if ([[NSString stringWithFormat:@"%@",newsItem[@"urlToImage"]] isEqualToString:@"<null>"])
        return [UIImage imageNamed:@"no_image"];
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@",newsItem[@"urlToImage"]]];
    NSData *imagedata = [NSData dataWithContentsOfURL:url];
    UIImage *newsImage = [UIImage imageWithData:imagedata];
    return newsImage;
}

@end
