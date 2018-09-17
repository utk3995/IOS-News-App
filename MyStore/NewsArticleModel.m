//
//  NewsArticleModel.m
//  MyStore
//
//  Created by utkarsh.sri on 14/09/18.
//  Copyright © 2018 utkarsh.sri. All rights reserved.
//

#import "NewsArticleModel.h"

@implementation NewsArticleModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"source" : @"source",
             @"author" : @"author",
             @"title" : @"title",
             @"newsDescription" : @"description",
             @"url" : @"url",
             @"urlToImage" : @"urlToImage",
             @"publishedAt" : @"publishedAt",
             @"content" : @"content",
             };
}

@end
