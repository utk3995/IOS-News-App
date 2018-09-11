//
//  NewsSuccessModel.m
//  MyStore
//
//  Created by utkarsh.sri on 04/09/18.
//  Copyright © 2018 utkarsh.sri. All rights reserved.
//

#import "NewsSuccessModel.h"

@implementation NewsSuccessModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"status" : @"status",
             @"totalResults" : @"totalResults",
             @"articles" : @"articles"
             };
}

@end
