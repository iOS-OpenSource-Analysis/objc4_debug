//
//  CommonHeader.h
//  objc-debug
//
//  Created by  tbfungeek on 2020/2/9.
//

#ifndef CommonHeader_h
#define CommonHeader_h

#define INIT_WITH_CODER                                                 \
- (instancetype)initWithCoder:(NSCoder *)coder {                        \
    if(self = [super init]) {                                           \
        unsigned int outCount = 0;                                      \
        Ivar *varList = class_copyIvarList([self class], &outCount);    \
        for (unsigned int index = 0; index < outCount; index++) {       \
            const char *var = ivar_getName(varList[index]);             \
            if(!var || !strlen(var)) continue;                          \
            NSString *varName = [NSString stringWithUTF8String:var];    \
            id value = [coder decodeObjectForKey:varName];              \
            if(value) {                                                 \
                [self setValue:value forKey:varName];                   \
            }                                                           \
        }                                                               \
        free(varList);                                                  \
    }                                                                   \
    return self;                                                        \
}                                                                       \

#define ENCODE_WITH_CODER                                               \
- (void)encodeWithCoder:(NSCoder *)coder {                              \
    unsigned int outCount = 0;                                          \
    Ivar *varList = class_copyIvarList([self class], &outCount);        \
    for (unsigned int index = 0; index < outCount; index++) {           \
        const char *var = ivar_getName(varList[index]);                 \
        if(!var || !strlen(var)) continue;                              \
        NSString *varName = [NSString stringWithUTF8String:var];        \
        id value = [self valueForKey:varName];                          \
        [coder encodeObject:value forKey:varName];                      \
    }                                                                   \
    free(varList);                                                      \
}                                                                       \

#endif /* CommonHeader_h */
