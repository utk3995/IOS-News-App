//
//  NewsTableView.h
//  MyStore
//
//  Created by utkarsh.sri on 04/09/18.
//  Copyright © 2018 utkarsh.sri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSArray *newsArray;

@end
