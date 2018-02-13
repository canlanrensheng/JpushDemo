//
//  TXAlertView.h
//  ZhuanMCH
//
//  Created by txooo on 16/7/17.
//  Copyright © 2016年 黄宜波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 alert按钮执行回调
 @param buttonIndex 按钮index
 */
typedef void (^TXAlertClickBlock)(NSInteger buttonIndex);
typedef NS_ENUM(NSInteger, TXAlertViewStyle) {
    TXAlertViewStyleAlert = 0,
    TXAlertViewStyleActionSheet
};

@interface TXAlertView : NSObject

+ (void)showAlert:(nullable NSString *)message;

+ (void)showAlert:(nullable NSString *)message buttonTitle:(nullable NSString *)buttonTitle;

+ (void)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

+ (void)showAlert:(nullable NSString *)message
      buttonTitle:(nullable NSString *)buttonTitle
 buttonIndexBlock:(nullable TXAlertClickBlock)buttonIndexBlock;

+ (void)showAlert:(nullable NSString *)message
cancelButtonTitle:(nullable NSString *)cancelButtonTitle
 buttonIndexBlock:(nullable TXAlertClickBlock)buttonIndexBlock
otherButtonTitle:(nullable NSString *)otherButtonTitle;

+ (void)showActionSheet:(nullable NSString *)message
      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
       buttonIndexBlock:(nullable TXAlertClickBlock)buttonIndexBlock
      otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 @param controller        默认为UIWindow的rootViewController
 @param title             title
 @param message           message
 @param cancelButtonTitle 取消按钮标题
 @param style             弹窗样式alert/actionsheet
 @param buttonIndexBlock  按钮回调
 @param otherButtonTitles 其他按钮标题列表
 */
+ (void)showAlertWithTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
         cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                    style:(TXAlertViewStyle)style
          buttonIndexBlock:(nullable TXAlertClickBlock)buttonIndexBlock
         otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
@end
