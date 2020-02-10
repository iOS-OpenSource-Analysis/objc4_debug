//
//  IDLBaseKVCObject.m
//  objc-debug
//
//  Created by  tbfungeek on 2020/2/10.
//

#import "IDLBaseKVCObject.h"

@interface IDLBaseKVCObject () {
    NSString *privateValue;
    NSString *value;
    NSString *_valueUnderLine;
    NSString *isValue;
    NSString *_isValueUnderLine;
}


@end

@implementation IDLBaseKVCObject

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"setValue:forUndefinedKey: key = %@ value=%@",key,value);
}

- (void)setNilValueForKey:(NSString *)key {
    
}

- (id)valueForUndefinedKey:(NSString *)key {
    return @"";
}

+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}

- (BOOL)validateValue:(inout id  _Nullable __autoreleasing *)ioValue forKey:(NSString *)inKey error:(out NSError *__autoreleasing  _Nullable *)outError {
    id value = *ioValue;
    if(![inKey isEqualToString:@"valueLargeThan10"]) return YES;
    if([value isKindOfClass:[NSNumber class]]) {
        NSInteger numberValue = [value integerValue];
        if(numberValue <10) {
            *outError = [NSError errorWithDomain:@"KVC" code:100 userInfo:nil];
            return NO;
        }
    }
    return YES;
}

@end
