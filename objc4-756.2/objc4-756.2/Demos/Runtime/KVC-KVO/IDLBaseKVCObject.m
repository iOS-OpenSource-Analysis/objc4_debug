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

+ (NSSet<NSString *> *)keyPathsForValuesAffectingFullName {
    return [NSSet setWithObjects:@"firstName",@"secondName", nil];
}

- (void)triggerInnerValue {
    [super willChangeValueForKey:@"triggerByInner"];
    //由于这里的_triggerByInner不是通过setter方法y以及keyPath方法设置的所以不会自动触发KVO，所以需要这里手动触发
    _triggerByInner = @"set Inner Value";
    [super didChangeValueForKey:@"triggerByInner"];
}

//根据key来决定是否自动触发KVO
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    return YES;
}

@end
