//
//  AppDelegate.h
//  AdoboApp
//
//  Created by Eunice Saldivar on 7/14/15.
//  Copyright (c) 2015 jumpdigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    ViewController * viewController;
    
}


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController * navigationController;



@end
