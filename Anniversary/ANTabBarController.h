//
//  ANTabBarController.h
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/12/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANTabBarController : UITabBarController <
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *tabBarImageView;

@end
