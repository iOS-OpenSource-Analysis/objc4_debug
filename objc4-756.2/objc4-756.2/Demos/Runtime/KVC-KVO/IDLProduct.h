//
//  IDLProduct.h
//  objc-debug
//
//  Created by  tbfungeek on 2020/2/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IDLProduct : NSObject

@property(nonatomic, strong, readwrite) NSString *name;
@property(nonatomic, assign, readwrite) NSInteger price;

@end

NS_ASSUME_NONNULL_END
