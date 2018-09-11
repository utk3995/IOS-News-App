//
//  NewsFailureModel.m
//  MyStore
//
//  Created by utkarsh.sri on 04/09/18.
//  Copyright © 2018 utkarsh.sri. All rights reserved.
//

#import "NewsFailureModel.h"

@implementation NewsFailureModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"status" : @"status",
             @"code" : @"code",
             @"message" : @"message"
             };
}

@end
