//
//  ANUploadViewController.m
//  Anniversary
//
//  Created by Lee Chih-Wei on 4/7/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANUploadViewController.h"
#import "ANAppDelegate.h"
#import "ANHTTPClient.h"
#import "SVProgressHUD.h"

@interface ANUploadViewController ()

- (void)processImage:(UIImage *)image;
- (BOOL)checkFacebookAuthorized;

@end

@implementation ANUploadViewController

@synthesize image = _image;
@synthesize isUploadingToStage = _isUploadingToStage;
@synthesize isUploadingToFacebook = _isUploadingToFacebook;

#pragma mark - Class

+ (ANUploadViewController *)uploadViewControllerWithImage:(UIImage *)image {
  QRootElement *root = [[QRootElement alloc] init];
  root.title = @"上傳照片";
  root.grouped = YES;
  root.controllerName = @"ANUploadViewController";
  
  QSection *section0 = [[QSection alloc] init];
  
  QTextElement *textElement = [[QTextElement alloc] init];
  textElement.text = [NSString stringWithContentsOfFile:NIPathForBundleResource([NSBundle mainBundle], @"description.txt") encoding:NSUTF8StringEncoding error:nil];
  textElement.font = [UIFont systemFontOfSize:12];
  textElement.color = [UIColor colorWithRed:0.878 green:0.271 blue:0.325 alpha:1.000];
  
  [section0 addElement:textElement];
  
  [root addSection:section0];
  
  QSection *section1 = [[QSection alloc] init];
  QBooleanElement *uploadElement = [[QBooleanElement alloc] initWithTitle:@"參加活動" BoolValue:YES];
  uploadElement.controllerAction = @"uploadSwitched:";
  QBooleanElement *facebookElement = [[QBooleanElement alloc] initWithTitle:@"分享到 Facebook" BoolValue:YES];
  facebookElement.controllerAction = @"facebookSwitched:";
  
  [section1 addElement:uploadElement];
  [section1 addElement:facebookElement];
  
  [root addSection:section1];
  
  ANUploadViewController *viewController = (ANUploadViewController *)[QuickDialogController controllerForRoot:root];
  viewController.image = image;
  
  return viewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    _isUploadingToStage = YES;
    _isUploadingToFacebook = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookDidLogin:) name:kNotificationFacebookDidLogin object:nil];
  }
  
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)facebookDidLogin:(NSNotification *)notification {
  [self processImage:self.image];
}

- (BOOL)checkFacebookAuthorized {
  BOOL isSessionValid = [[ANAtlas sharedFacebook] isSessionValid];
  if (!isSessionValid) {
    [[ANAtlas sharedFacebook] authorize:[NSArray arrayWithObjects:@"email", @"publish_stream", nil]];
  }
  
  return isSessionValid;
}

- (void)uploadSwitched:(QBooleanElement *)element {
  _isUploadingToStage = element.boolValue;
}

- (void)facebookSwitched:(QBooleanElement *)element {
  _isUploadingToFacebook = element.boolValue;
}

- (void)processImage:(UIImage *)image {
  NSData *data = UIImageJPEGRepresentation(image, 0.9);
  UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
  
  if (_isUploadingToFacebook || _isUploadingToStage) {
    [SVProgressHUD showWithStatus:@"上傳中"];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
  } else {
    [SVProgressHUD showSuccessWithStatus:@"已存入相片圖庫" duration:1.5];
    [self dismissModalViewControllerAnimated:YES];
    return;
  }
  
  if (_isUploadingToFacebook) {
    [[ANAtlas sharedFacebook] requestWithGraphPath:@"me/photos" andParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:data, @"source", nil] andHttpMethod:@"POST" andDelegate:nil];
  }
  
  if (_isUploadingToStage) {  
    CLLocationCoordinate2D locationCoordinate = [[[(ANAppDelegate *)[[UIApplication sharedApplication] delegate] locationManager] location] coordinate];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [[NSUserDefaults standardUserDefaults] objectForKey:@"FBAccessTokenKey"], 
                            @"access_token", 
                            [NSNumber numberWithDouble:locationCoordinate.latitude], 
                            @"photo[latitude]", 
                            [NSNumber numberWithDouble:locationCoordinate.longitude], 
                            @"photo[longitude]", nil];
    
    NSMutableURLRequest *request = [[ANHTTPClient sharedClient] multipartFormRequestWithMethod:@"POST" 
                                                                                          path:@"photos.json" 
                                                                                    parameters:params 
                                                                     constructingBodyWithBlock:^(id<AFMultipartFormData>formData) {
                                                                       [formData appendPartWithFileData:data name:@"photo[image]" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                                                                     }];
    
    __weak ANUploadViewController *tempSelf = self;
    AFHTTPRequestOperation *operation = [[ANHTTPClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
      [SVProgressHUD dismiss];
      [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPhotosNeedsRefresh object:nil];
      [tempSelf dismissModalViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
      [SVProgressHUD dismiss];
      tempSelf.navigationItem.rightBarButtonItem.enabled = YES;
      tempSelf.navigationItem.leftBarButtonItem.enabled = YES;
      [UIAlertView showAlertViewWithTitle:@"上傳失敗" message:@"請檢查網路連線，稍後重新再試一次。" cancelButtonTitle:@"完成" otherButtonTitles:nil handler:NULL];
    }];
    
    [[ANHTTPClient sharedClient] enqueueHTTPRequestOperation:operation];
  }
}

#pragma mark - UIViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  __weak ANUploadViewController *tempSelf = self;
  
  UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
  [cancelButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
  [cancelButton addEventHandler:^(id sender){
    [tempSelf.navigationController popViewControllerAnimated:YES];
  } forControlEvents:UIControlEventTouchUpInside];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
  
  UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
  [doneButton setImage:[UIImage imageNamed:@"doneButton"] forState:UIControlStateNormal];
  [doneButton addEventHandler:^(id sender){
    if ((!tempSelf.isUploadingToStage && !tempSelf.isUploadingToFacebook) || [tempSelf checkFacebookAuthorized]) {
      [tempSelf processImage:tempSelf.image];
    }
  } forControlEvents:UIControlEventTouchUpInside];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
}


@end
