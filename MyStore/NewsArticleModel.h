//
//  NewsArticleModel.h
//  MyStore
//
//  Created by utkarsh.sri on 14/09/18.
//  Copyright © 2018 utkarsh.sri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface NewsArticleModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSDictionary *source;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *newsDescription;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *urlToImage;
@property (nonatomic, copy) NSString *publishedAt;
@property (nonatomic, copy) NSString *content;

@end
