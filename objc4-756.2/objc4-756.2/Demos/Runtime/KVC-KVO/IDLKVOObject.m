//
//  IDLKVOObject.m
//  objc-debug
//
//  Created by  tbfungeek on 2020/2/10.
//

#import "IDLKVOObject.h"

@interface IDLKVOObject ()

@end

@implementation IDLKVOObject

- (instancetype)init {
    if (self = [super init]) {
        _objects = [[IDLBaseKVCObject alloc] init];
        [_objects addObserver:self forKeyPath:@"propertyForKVO" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [_objects addObserver:self forKeyPath:@"fullName" options:NSKeyValueObservingOptionNew context:nil];
        [_objects addObserver:self forKeyPath:@"triggerByInner" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
}

- (void)dealloc {
    [_objects removeObserver:self forKeyPath:@"propertyForKVO"];
    [_objects removeObserver:self forKeyPath:@"fullName"];
}

- (void)triggerInnerValue {
    [_objects triggerInnerValue];
}

@end
