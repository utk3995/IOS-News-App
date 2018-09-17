//
//  News.h
//  MyStore
//
//  Created by utkarsh.sri on 14/09/18.
//  Copyright © 2018 utkarsh.sri. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface News : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * publishedAt;
@property (nonatomic, retain) NSString * urlToImage;
@property (nonatomic, retain) NSString * url;

@end
