//
//  ANUploadViewController.m
//  Anniversary
//
//  Created by Lee Chih-Wei on 4/7/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANUploadViewController.h"

@interface ANUploadViewController ()

@end

@implementation ANUploadViewController

@synthesize image = _image;

#pragma mark - Class

+ (ANUploadViewController *)uploadViewControllerWithImage:(UIImage *)image {
  QRootElement *root = [[QRootElement alloc] init];
  root.title = @"上傳照片";
  root.grouped = YES;
  root.controllerName = @"ANUploadViewController";
  
  QSection *section0 = [[QSection alloc] init];
  section0.title = @"活動說明";
  
  QTextElement *textElement = [[QTextElement alloc] init];
  textElement.text = @"大學副教授，夠浪漫，鄧麗君鳳飛飛被消費，我真的笑了，有瘦肉精，怎麼就是有人那麼再意臉書上寫什麼...以為幫別人求婚，為演狀況劇，這不是教學，上月失業率4.18，這隻獅子也太糗了!各位勞工朋友，但.....我們老板以前趕走的眾多postdoc中有那麼一個法國的phd，換，喝了杯咖啡，犧牲自己的假期，肉燥麵？";
  
  [section0 addElement:textElement];
  
  [root addSection:section0];
  
  QSection *section1 = [[QSection alloc] init];
  QBooleanElement *facebookButtonElement = [[QBooleanElement alloc] initWithTitle:@"分享到 Facebook" BoolValue:YES];
  QBooleanElement *saveToAlbumButtonElement = [[QBooleanElement alloc] initWithTitle:@"儲存到本機相簿" BoolValue:YES];
  
  [section1 addElement:facebookButtonElement];
  [section1 addElement:saveToAlbumButtonElement];
  
  [root addSection:section1];
  
  QSection *section2 = [[QSection alloc] init];
  QButtonElement *acceptButton = [[QButtonElement alloc] initWithTitle:@"參加活動"];
  QButtonElement *cancelButton = [[QButtonElement alloc] initWithTitle:@"不參加活動"];
  
  [section2 addElement:acceptButton];
  [section2 addElement:cancelButton];
  
  [root addSection:section2];
  
  ANUploadViewController *viewController = (ANUploadViewController *)[QuickDialogController controllerForRoot:root];
  viewController.image = image;
  
  return viewController;
}

@end
