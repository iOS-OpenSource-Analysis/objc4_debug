//
//  IDLTestObject.h
//  objc-debug
//
//  Created by  tbfungeek on 2020/2/8.
//

#import <Foundation/Foundation.h>

@interface IDLReturnType : NSObject

@end

NS_ASSUME_NONNULL_BEGIN

@interface IDLTestObject : NSObject {
    NSString *privateInstanceVar;
}

@property(nonatomic, strong, readwrite) NSString *name;

@property(nonatomic, copy, readonly,getter=ageValue,setter=setAageValue:) NSString *age;

- (void)testInstanceMethod;

+ (IDLReturnType *)testTypeEncoding:(NSString *)strValue intValue:(NSInteger)intValue charValue:(char *)charValue;

@end

NS_ASSUME_NONNULL_END
