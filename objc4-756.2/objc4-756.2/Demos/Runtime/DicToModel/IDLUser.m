//
//  IDLUser.m
//  objc-debug
//
//  Created by  tbfungeek on 2020/2/9.
//

#import "IDLUser.h"
#import <objc/runtime.h>
#import "CommonHeader.h"

@implementation IDLTopic

INIT_WITH_CODER

ENCODE_WITH_CODER

@end

@implementation IDLUser

+ (NSDictionary *)arrayElementModelTypeMap {
    return @{@"topics":[IDLTopic class]};
}

INIT_WITH_CODER

ENCODE_WITH_CODER

@end
