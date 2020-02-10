//
//  IDLKVOObject.h
//  objc-debug
//
//  Created by  tbfungeek on 2020/2/10.
//

#import <Foundation/Foundation.h>

#import "IDLBaseKVCObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface IDLKVOObject : NSObject

@property(nonatomic, strong, readwrite) IDLBaseKVCObject *objects;

- (void)triggerInnerValue;

@end

NS_ASSUME_NONNULL_END
