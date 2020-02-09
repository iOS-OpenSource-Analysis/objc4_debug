//
//  NSObject+Model.h
//  objc-debug
//
//  Created by  tbfungeek on 2020/2/9.
//

#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Model)

+ (instancetype)idl_modelWithDic:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
