//
//  IDLUser.m
//  objc-debug
//
//  Created by  tbfungeek on 2020/2/9.
//

#import "IDLUser.h"

@implementation IDLTopic

@end

@implementation IDLUser

+ (NSDictionary *)arrayElementModelTypeMap {
    return @{@"topics":[IDLTopic class]};
}

@end
