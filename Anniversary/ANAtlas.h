//
//  ANAtlas.h
//  Anniversary
//
//  Created by Lee Chih-Wei on 3/18/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Facebook;

#pragma mark - API

#define kAPI_KEY_FACEBOOK @"364875846885282"
#define kAPI_BASE_URL @"http://nccu85.herokuapp.com/"

/*[GET] http://nccu85.herokuapp.com/photos
  參數:page - 分頁代號，目前一頁 16 筆資料
 {
 "created_at" = "2012-03-18T17:15:00Z";
 description = Apple;
 id = 13;
 image =         {
 thumb =             {
 url = "https://nccu85-development.s3.amazonaws.com/uploads/photo/image/13/thumb_Photo11.jpg";
 };
 url = "https://nccu85-development.s3.amazonaws.com/uploads/photo/image/13/Photo11.jpg";
 };
 "updated_at" = "2012-03-18T17:15:00Z";
 }
 
 [POST] http://nccu85.herokuapp.com/photos
 
 參數
 * photo[description] - 描述
 * photo[image] - 照片檔案（必備）

*/

#pragma mark - Photo Size Constant

#define kThumbPhotoWidth 130.0f
#define kThumbPhotoHeight 130.0f

#pragma mark - Notification

#define kNotificationFacebookDidLogin @"kNotificationFacebookDidLogin"


@interface ANAtlas : NSObject

+ (Facebook *)sharedFacebook;

@end
