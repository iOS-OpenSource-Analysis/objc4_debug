//
//  NSObject+Model.m
//  objc-debug
//
//  Created by  tbfungeek on 2020/2/9.
//

#import "NSObject+Model.h"

#import <AppKit/AppKit.h>

#import <objc/runtime.h>

@implementation NSObject (Model)

+ (instancetype)idl_modelWithDic:(NSDictionary *)dictionary {
    
    if(!dictionary || ![dictionary count]) return nil;
    
    id objc = [[self alloc] init];
    
    unsigned int outCount = 0;
    //没有参数的情况
    Ivar *varList = class_copyIvarList([self class], &outCount);
    if(!outCount) {
        free(varList);
        return objc;
    }
    
    for (unsigned int index = 0; index < outCount; index++) {
        
        //获取到属性名称
        NSString *varName = [NSString stringWithUTF8String:ivar_getName(varList[index])];
        if(!varName || ![varName length]) continue;
        //去掉下划线_
        varName = [varName substringFromIndex:1];
        //去掉@ 和 “ 之后的实例变量类型 获取到的时候类型为@"NSString"这种
        NSString *varType = [NSString stringWithUTF8String:ivar_getTypeEncoding(varList[index])];
        varType = [varType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        varType = [varType stringByReplacingOccurrencesOfString:@"@" withString:@""];
        
        //取得变量值
        id varValue = dictionary[varName];
        
        //自定义类型处理
        if([varValue isKindOfClass:[NSDictionary class]] || ![varType hasPrefix:@"NS"]) {
            //拿到自定义类型 递归生成 自定义的类型属性
            Class modelClass = NSClassFromString(varType);
            if(modelClass) {
                varValue = [modelClass idl_modelWithDic:varValue];
            }
        }
        
        //实例变量为数组类型
        if([varValue isKindOfClass:[NSArray class]] || [varValue isKindOfClass:[NSMutableArray class]]) {
            //获取映射的模型类型
            if([self respondsToSelector:@selector(arrayElementModelTypeMap)]) {
                //拿到元素类型
                NSDictionary *arrayElementModelTypeMap = [self performSelector:@selector(arrayElementModelTypeMap)];
                Class elementModelType = arrayElementModelTypeMap[varName];
                
                NSMutableArray *array = [NSMutableArray new];
                for (NSDictionary *dict in varValue/*这个为字典数组*/) {
                    id elementValue = [elementModelType idl_modelWithDic:dict];
                    [array addObject:elementValue];
                }
                varValue = array;
            }
        }
        
        //赋值
        if(varValue) {
            [objc setValue:varValue forKey:varName];
        }
    }
    free(varList);
    return objc;
}

@end
