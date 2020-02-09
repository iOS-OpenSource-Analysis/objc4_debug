//
//  IDLUser.h
//  objc-debug
//
//  Created by  tbfungeek on 2020/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IDLTopic : NSObject

@property(nonatomic, strong) NSString *topicName;

@property(nonatomic, assign) NSInteger topicRankStar;

@end

@interface IDLUser : NSObject

@property(nonatomic, strong) NSString *userName;

@property(nonatomic, assign) NSInteger userAge;

@property(nonatomic, strong) NSString *localAddress;

@property(nonatomic, strong) NSString *country;

@property(nonatomic, strong) NSArray<IDLTopic *> *topics;

@end

NS_ASSUME_NONNULL_END
