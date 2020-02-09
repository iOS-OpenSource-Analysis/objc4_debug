//
//  IDLTestObject.m
//  objc-debug
//
//  Created by  tbfungeek on 2020/2/8.
//

#import "IDLTestObject.h"

@implementation IDLReturnType

@end

@implementation IDLTestObject

- (void)testInstanceMethod {
    NSLog(@"run testInstanceMethod");
}

+ (void)testClassMethod {
    NSLog(@"testclassMethod");
}

+ (IDLReturnType *)testTypeEncoding:(NSString *)strValue intValue:(NSInteger)intValue charValue:(char *)charValue {
    return [IDLReturnType new];
}

@end
