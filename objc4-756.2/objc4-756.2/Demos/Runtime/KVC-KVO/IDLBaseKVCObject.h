//
//  IDLBaseKVCObject.h
//  objc-debug
//
//  Created by  tbfungeek on 2020/2/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IDLBaseKVCObject : NSObject 

@property(nonatomic, strong, readonly) NSString *readOnlyValue;

@property(nonatomic, strong, readwrite) NSString *propertyForKVO;

@property(nonatomic, strong, readwrite) NSString *fullName;
@property(nonatomic, strong, readwrite) NSString *firstName;
@property(nonatomic, strong, readwrite) NSString *secondName;

@property(nonatomic, strong, readwrite) NSString *triggerByInner;

- (void)triggerInnerValue;


@end

NS_ASSUME_NONNULL_END
