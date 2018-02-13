//
//  TXAlertView.m
//  ZhuanMCH
//
//  Created by txooo on 16/7/17.
//  Copyright © 2016年 黄宜波. All rights reserved.
//

#import "TXAlertView.h"

@interface TXAlertView()<UIAlertViewDelegate,UIActionSheetDelegate>

@end

@implementation TXAlertView
static TXAlertClickBlock buttonClickBlock;
static NSString *cancelTitle = nil;
- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

+ (void)showAlert:(NSString *)message {
    [[self class] showAlertWithTitle:nil message:message];
}

+ (void)showAlert:(NSString *)message buttonTitle:(NSString *)buttonTitle {
    [[self class] showAlert:message buttonTitle:buttonTitle buttonIndexBlock:nil];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    [[self class] showAlertWithTitle:title
                                 message:message
                       cancelButtonTitle:@"确定"
                                   style:TXAlertViewStyleAlert
                        buttonIndexBlock:nil
                       otherButtonTitles:nil, nil];
}

+ (void)showAlert:(NSString *)message
      buttonTitle:(nullable NSString *)buttonTitle
 buttonIndexBlock:(nullable TXAlertClickBlock)buttonIndexBlock {
    [[self class] showAlert:message
          cancelButtonTitle:buttonTitle
           buttonIndexBlock:buttonIndexBlock
          otherButtonTitle:nil];
}

+ (void)showAlert:(NSString *)message
cancelButtonTitle:(NSString *)cancelButtonTitle
 buttonIndexBlock:(TXAlertClickBlock)buttonIndexBlock
otherButtonTitle:(NSString *)otherButtonTitles{
    [[self class] showAlertWithTitle:nil
                                 message:message
                       cancelButtonTitle:cancelButtonTitle
                                   style:TXAlertViewStyleAlert
                        buttonIndexBlock:buttonIndexBlock
                       otherButtonTitles:otherButtonTitles, nil];
}

+ (void)showActionSheet:(NSString *)message
      cancelButtonTitle:(NSString *)cancelButtonTitle
       buttonIndexBlock:(TXAlertClickBlock)buttonIndexBlock
      otherButtonTitles:(NSString *)otherButtonTitles, ... {
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    cancelTitle = cancelButtonTitle;
    buttonClickBlock = buttonIndexBlock;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIAlertControllerStyle alertStyle = UIAlertControllerStyleActionSheet;UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:alertStyle];
        if (cancelButtonTitle) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (buttonClickBlock) {
                    buttonClickBlock(0);
                }
                
            }];
            [alertController addAction:action];
        }
        if (otherButtonTitles){
            va_list args;//定义一个指向个数可变的参数列表指针
            va_start(args, otherButtonTitles);//得到第一个可变参数地址
            int index = cancelButtonTitle ? 1 : 0;
            for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString *)){
                UIAlertAction *action = [UIAlertAction actionWithTitle:arg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (buttonClickBlock) {
                        buttonClickBlock(index);
                    }
                }];
                [alertController addAction:action];
                index++;
            }
            va_end(args);//置空指针
        }
        [controller presentViewController:alertController animated:YES completion:nil];
    }else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:buttonClickBlock ? (TXAlertView *)self : nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:otherButtonTitles,nil];
        if (otherButtonTitles) {
            NSMutableArray *buttonsArray = [NSMutableArray array];
            id buttonTitle = nil;
            va_list argumentList;
            va_start(argumentList, otherButtonTitles);
            while ((buttonTitle=(__bridge NSString *)va_arg(argumentList, void *))) {
                [buttonsArray addObject:buttonTitle];
            }
            va_end(argumentList);
            
            for(NSString *otherTitle in buttonsArray){
                [actionSheet addButtonWithTitle:otherTitle];
            }
        }
        if (cancelButtonTitle) {
            [actionSheet addButtonWithTitle:cancelButtonTitle];
            actionSheet.cancelButtonIndex = actionSheet.numberOfButtons-1;
        }
        [actionSheet showInView:controller.view];
    }
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle
                     style:(TXAlertViewStyle)style
          buttonIndexBlock:(TXAlertClickBlock)buttonIndexBlock
         otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if (!(title.length > 0) && message.length > 0) {
        title = @"";
    }
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([controller isKindOfClass:[UITabBarController class]]) {
        controller = [(UITabBarController *)controller selectedViewController];
        if ([controller isKindOfClass:[UINavigationController class]]) {
            controller = [(UINavigationController *)controller visibleViewController];
        }
    }else if ([controller isKindOfClass:[UINavigationController class]]) {
        controller = [(UINavigationController *)controller visibleViewController];
    }
    cancelTitle = cancelButtonTitle;
    buttonClickBlock = buttonIndexBlock;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIAlertControllerStyle alertStyle;
        if (style == TXAlertViewStyleAlert) {
            alertStyle = UIAlertControllerStyleAlert;
        }else {
            alertStyle = UIAlertControllerStyleActionSheet;
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:alertStyle];
        if (cancelButtonTitle) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (buttonClickBlock) {
                    buttonClickBlock(0);
                }
                
            }];
            [alertController addAction:action];
        }
        if (otherButtonTitles){
            va_list args;//定义一个指向个数可变的参数列表指针
            va_start(args, otherButtonTitles);//得到第一个可变参数地址
            int index = cancelButtonTitle ? 1 : 0;
            for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString *)){
                UIAlertAction *action = [UIAlertAction actionWithTitle:arg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (buttonClickBlock) {
                        buttonClickBlock(index);
                    }
                }];
                [alertController addAction:action];
                index++;
            }
            va_end(args);//置空指针
        }
        [controller presentViewController:alertController animated:YES completion:nil];
    }else{
        if (style == TXAlertViewStyleAlert) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate: buttonClickBlock ? (TXAlertView *)self : nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
            if (otherButtonTitles) {
                NSMutableArray *buttonsArray = [NSMutableArray array];
                id buttonTitle = nil;
                va_list argumentList;
                va_start(argumentList, otherButtonTitles);
                while ((buttonTitle=(__bridge NSString *)va_arg(argumentList, void *))) {
                    [buttonsArray addObject:buttonTitle];
                }
                va_end(argumentList);
                
                for(NSString *otherTitle in buttonsArray) {
                    [alert addButtonWithTitle:otherTitle];
                }
            }
            if (cancelButtonTitle) {
                alert.cancelButtonIndex = 0;
            }
            [alert show];
        }else if(style == TXAlertViewStyleActionSheet){
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:buttonClickBlock ? (TXAlertView *)self : nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:otherButtonTitles,nil];
            if (otherButtonTitles) {
                NSMutableArray *buttonsArray = [NSMutableArray array];
                id buttonTitle = nil;
                va_list argumentList;
                va_start(argumentList, otherButtonTitles);
                while ((buttonTitle=(__bridge NSString *)va_arg(argumentList, void *))) {
                    [buttonsArray addObject:buttonTitle];
                }
                va_end(argumentList);
                
                for(NSString *otherTitle in buttonsArray){
                    [actionSheet addButtonWithTitle:otherTitle];
                }
            }
            if (cancelButtonTitle) {
                [actionSheet addButtonWithTitle:cancelButtonTitle];
                actionSheet.cancelButtonIndex = actionSheet.numberOfButtons-1;
            }
            [actionSheet showInView:controller.view];
        }
    }
}

#pragma mark
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonClickBlock) {
        buttonClickBlock(buttonIndex);
    }
    buttonClickBlock = NULL;//解除闭环
}

+ (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (cancelTitle && buttonIndex == actionSheet.cancelButtonIndex) {
        if (buttonClickBlock) {
            buttonClickBlock(0);
        }
        buttonClickBlock = NULL;
        return;
    }else if (cancelTitle){
        if (buttonClickBlock) {
            buttonClickBlock(buttonIndex + 1);
        }
        buttonClickBlock = NULL;
        return;
    }else {
        if (buttonClickBlock) {
            buttonClickBlock(buttonIndex);
        }
        buttonClickBlock = NULL;
    }
    cancelTitle = nil;
}

@end
