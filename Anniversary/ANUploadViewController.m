//
//  ANUploadViewController.m
//  Anniversary
//
//  Created by Lee Chih-Wei on 4/7/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANUploadViewController.h"
#import "ANHTTPClient.h"

@interface ANUploadViewController ()

- (void)processImage:(UIImage *)image;
- (BOOL)checkFacebookAuthorized;

@end

@implementation ANUploadViewController

@synthesize image = _image;
@synthesize isUploadingToFacebook = _isUploadingToFacebook;
@synthesize isSavingToAlbum = _isSavingToAlbum;

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
  QBooleanElement *saveToAlbumElement = [[QBooleanElement alloc] initWithTitle:@"儲存到本機相簿" BoolValue:YES];
  saveToAlbumElement.controllerAction = @"saveToAlbumSwitched:";
  QBooleanElement *facebookElement = [[QBooleanElement alloc] initWithTitle:@"分享到 Facebook" BoolValue:YES];
  facebookElement.controllerAction = @"facebookSwitched:";
  
  [section1 addElement:facebookElement];
  [section1 addElement:saveToAlbumElement];
  
  [root addSection:section1];
  
  QSection *section2 = [[QSection alloc] init];
  QButtonElement *acceptButton = [[QButtonElement alloc] initWithTitle:@"參加活動"];
  acceptButton.controllerAction = @"acceptButtonClicked:";
  QButtonElement *declineButton = [[QButtonElement alloc] initWithTitle:@"不參加活動"];
  declineButton.controllerAction = @"declineButtonClicked:";
  
  [section2 addElement:acceptButton];
  [section2 addElement:declineButton];
  
  [root addSection:section2];
  
  ANUploadViewController *viewController = (ANUploadViewController *)[QuickDialogController controllerForRoot:root];
  viewController.image = image;
  
  return viewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    _isSavingToAlbum = YES;
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

- (void)facebookSwitched:(QBooleanElement *)element {
  _isUploadingToFacebook = element.boolValue;
}

- (void)saveToAlbumSwitched:(QBooleanElement *)element {
  _isSavingToAlbum = element.boolValue;
}

- (void)processImage:(UIImage *)image {
  NSData *data = UIImageJPEGRepresentation(image, 0.9);
  
  if (_isSavingToAlbum) {
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
  }
  
  if (_isUploadingToFacebook) {
    [[ANAtlas sharedFacebook] requestWithGraphPath:@"me/photos" andParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:data, @"source", nil] andHttpMethod:@"POST" andDelegate:nil];
  }
  
  NSMutableURLRequest *request = [[ANHTTPClient sharedClient] multipartFormRequestWithMethod:@"POST" path:@"photos.json" parameters:[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"FBAccessTokenKey"], @"access_token", nil] constructingBodyWithBlock:^(<AFMultipartFormData>formData) {
    [formData appendPartWithFileData:data name:@"photo[image]" fileName:@"image.jpg" mimeType:@"image/jpeg"];
  }];
  
  AFHTTPRequestOperation *operation = [[ANHTTPClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
    [self dismissModalViewControllerAnimated:YES];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    [UIAlertView showAlertViewWithTitle:@"上傳失敗" message:@"請檢查網路連線，稍後重新再試一次。" cancelButtonTitle:@"完成" otherButtonTitles:nil handler:NULL];
  }];
  
  [[ANHTTPClient sharedClient] enqueueHTTPRequestOperation:operation];
}

- (void)acceptButtonClicked:(QButtonElement *)element {
  if ([self checkFacebookAuthorized]) {
    [self processImage:self.image];
  }
}

- (void)declineButtonClicked:(QButtonElement *)element {
  [self dismissModalViewControllerAnimated:YES];
}


@end
