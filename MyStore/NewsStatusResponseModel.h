//
//  NewsModel.h
//  MyStore
//
//  Created by utkarsh.sri on 04/09/18.
//  Copyright © 2018 utkarsh.sri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface NewsStatusResponseModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *status;

@end
