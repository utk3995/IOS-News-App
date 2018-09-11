//
//  AppDelegate.h
//  MyStore
//
//  Created by utkarsh.sri on 29/08/18.
//  Copyright © 2018 utkarsh.sri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

