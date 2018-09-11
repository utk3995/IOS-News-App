//
//  NewsFailureModel.h
//  MyStore
//
//  Created by utkarsh.sri on 04/09/18.
//  Copyright © 2018 utkarsh.sri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface NewsFailureModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *message;

@end
