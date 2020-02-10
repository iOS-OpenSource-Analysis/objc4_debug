//
//  main.m
//  objc-debug
//
//  Created by Cooci on 2019/10/9.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "IDLTestObject.h"
#import "NSObject+Model.h"
#import "IDLUser.h"

#import "IDLBaseKVCObject.h"
#import "IDLProduct.h"

void addedMethodIMP(id object,SEL select) {
    NSLog(@"run addedMethodIMP");
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSObject *object = [NSObject alloc];
        NSLog(@"Hello, World! %@",object);
        
        //获取类名
        const char *className = class_getName([IDLTestObject class]);
        NSLog(@"className : %@",[NSString stringWithUTF8String:className]);
        
        //获取父类
        Class superClass = class_getSuperclass([IDLTestObject class]);
        NSLog(@"superClass : %@", NSStringFromClass(superClass));
        
        //获取实例对象的大小
        size_t instanceSize = class_getInstanceSize([IDLTestObject class]);
        NSLog(@"instanceSize = %zu",instanceSize);
    
        //获取实例变量信息 如果没有找到会返回nil
        Ivar nameVar = class_getInstanceVariable([IDLTestObject class], [@"_name" UTF8String]);
        NSLog(@"InstanceVariable :%@",[NSString stringWithUTF8String:ivar_getName(nameVar)]);
        NSLog(@"Instance Variable TypeEncoding:%@",[NSString stringWithUTF8String:ivar_getTypeEncoding(nameVar)]);
        NSLog(@"Instance Variable Offset:%td",ivar_getOffset(nameVar));
        
        //获取实例变量列表
        unsigned int outCount = 0;
        Ivar *varList = class_copyIvarList([IDLTestObject class], &outCount);
        for (unsigned int index = 0 ;index < outCount; index++) {
            NSLog(@"var %u = %@",index,[NSString stringWithUTF8String:ivar_getName(varList[index])]);
        }
        free(varList);
        
        //获取对象属性
        objc_property_t property = class_getProperty([IDLTestObject class], [@"age" UTF8String]);
        NSLog(@"Instance Property Name :%@",[NSString stringWithUTF8String:property_getName(property)]);
        NSLog(@"Instance Property Attribute:%@",[NSString stringWithUTF8String:property_getAttributes(property)]);
        
        //获取实例方法
        Method method = class_getInstanceMethod([IDLTestObject class], @selector(testInstanceMethod));
        NSLog(@"get InstanceMethod %@",NSStringFromSelector(method_getName(method)));
        
        //获取方法列表
        Method *methodList = class_copyMethodList([IDLTestObject class], &outCount);
        for (unsigned int index = 0; index < outCount; index++) {
            NSLog(@"method %u = %@",index,NSStringFromSelector(method_getName(methodList[index])));
        }
        free(methodList);
        
        //获取类方法
        Method classMethod = class_getClassMethod([IDLTestObject class], @selector(testClassMethod));
        NSLog(@"get classMethod %@",NSStringFromSelector(method_getName(classMethod)));
        
        IMP testMethod = class_getMethodImplementation([IDLTestObject class], @selector(testInstanceMethod));
        testMethod();
        
        
        //给某个类添加方法
        class_addMethod([IDLTestObject class],
                        @selector(addedMethod),
                        (IMP)addedMethodIMP,
                        "v@:");
        
        [[IDLTestObject new] performSelector:@selector(addedMethod)];
        
        objc_property_attribute_t type = { "T", "@\"NSString\"" };  //T：类型
        objc_property_attribute_t ownership = { "C", "" };          // C：copy
        objc_property_attribute_t nonatomic = { "N", "" };          // N：nonatomic
        objc_property_attribute_t ivar  = { "V", "_addedMethod" };  //V： 实例变量变量名
        objc_property_attribute_t attributs[] = { type, ownership,nonatomic, ivar };
        class_addProperty([IDLTestObject class], "addedMethod", attributs, 4);

        //输出添加的成员变量
        unsigned int count;
        objc_property_t *propertyList = class_copyPropertyList([IDLTestObject class], &count);
        for (unsigned int i = 0; i< count; i++) {
            const char *name = property_getName(propertyList[i]);
            NSLog(@"属性%@ 属性信息%@",[NSString stringWithUTF8String:name],
                  [NSString stringWithUTF8String:property_getAttributes(propertyList[i])]);
        }
        free(propertyList);
        
        //替换方法
        class_replaceMethod([IDLTestObject class],
                            @selector(testInstanceMethod),
                            (IMP)addedMethodIMP,
                            "v@:");
        [[[IDLTestObject alloc] init] testInstanceMethod];
        
        //创建实例
        IDLTestObject *testClass = class_createInstance([IDLTestObject class], 0);
        [testClass performSelector:@selector(testInstanceMethod)];
        

        Class DynamicClass = objc_allocateClassPair([NSObject class], "DynamicClass", 0);
        class_addIvar(DynamicClass, "_attribute0", sizeof(NSString *), log(sizeof(NSString *)), "i");
        Ivar dynamicIvar = class_getInstanceVariable(DynamicClass, "_attribute0");
        NSLog(@"DynamicClass var:%@",[NSString stringWithUTF8String:ivar_getName(dynamicIvar)]);
        objc_registerClassPair(DynamicClass);
        
        unsigned int outCnt = 0;
        Protocol * __unsafe_unretained * protocalList = objc_copyProtocolList(&outCnt);
        for (unsigned int index = 0; index < outCnt; index++) {
            Protocol *pro = protocalList[index];
            //NSLog(@"%@",NSStringFromProtocol(pro));
        }
        free(protocalList);
        
        
        Method testMethods = class_getClassMethod([IDLTestObject class], @selector(testTypeEncoding:intValue:charValue:));
        NSLog(@"Type Encoding : %@",[NSString stringWithUTF8String:method_getTypeEncoding(testMethods)]);
        char *returnType = method_copyReturnType(testMethods);
        NSLog(@"Return Type: %@",[NSString stringWithUTF8String:returnType]);
        free(returnType);
        NSInteger numberOfArguments = method_getNumberOfArguments(testMethods);
        char *argument = NULL;
        struct objc_method_description *methodDescription = method_getDescription(testMethods);
        for (unsigned int index = 0; index < numberOfArguments; index++) {
            argument = method_copyArgumentType(testMethods, index);
            NSLog(@"Index %d Return Type: %@", index,[NSString stringWithUTF8String:argument]);
        }
        free(argument);
        
        NSLog(@"char     : %s, %lu", @encode(char), sizeof(char));
        NSLog(@"short    : %s, %lu", @encode(short), sizeof(short));
        NSLog(@"int      : %s, %lu", @encode(int), sizeof(int));
        NSLog(@"long     : %s, %lu", @encode(long), sizeof(long));
        NSLog(@"long long: %s, %lu", @encode(long long), sizeof(long long));
        NSLog(@"float    : %s, %lu", @encode(float), sizeof(float));
        NSLog(@"double   : %s, %lu", @encode(double), sizeof(double));
        NSLog(@"NSInteger: %s, %lu", @encode(NSInteger), sizeof(NSInteger));
        NSLog(@"CGFloat  : %s, %lu", @encode(CGFloat), sizeof(CGFloat));
        NSLog(@"int32_t  : %s, %lu", @encode(int32_t), sizeof(int32_t));
        NSLog(@"int64_t  : %s, %lu", @encode(int64_t), sizeof(int64_t));
    
        
        IDLUser *user = [IDLUser idl_modelWithDic:@{
            @"userName":@"jimmy",
            @"userAge":@(29),
            @"localAddress":@"广东广州",
            @"country":@"CN",
            @"topics":@[
                            @{@"topicName":@"test",@"topicRankStar":@(100)},
                            @{@"topicName":@"test1",@"topicRankStar":@(102)}
                      ]}];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
        id userObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"IDLUser = %@",user);
        
        
        //KVC 基本用法
        IDLBaseKVCObject *kvcObject = [IDLBaseKVCObject new];
        [kvcObject setValue:@"readOnlyValue" forKey:@"readOnlyValue"];
        [kvcObject setValue:@"privateValue" forKey:@"privateValue"];
        [kvcObject setValue:@"valueUnderLine" forKey:@"valueUnderLine"];
        [kvcObject setValue:@"isValue" forKey:@"isValue"];
        [kvcObject setValue:@"isValueUnderLine" forKey:@"isValueUnderLine"];
        
        //validateValue 用法
        NSError *error = nil;
        NSNumber *intValue = @4;
        BOOL result = [kvcObject validateValue:&intValue forKey:@"valueLargeThan10" error:&error];
        
        //字典转模型/模型转字典
        NSDictionary *dict = [kvcObject dictionaryWithValuesForKeys:@[@"readOnlyValue",@"privateValue",@"valueUnderLine",@"isValue",@"isValueUnderLine"]];
        IDLBaseKVCObject *value = [IDLBaseKVCObject new];
        [value setValuesForKeysWithDictionary:dict];
        [value setValue:@"NULL" forKey:@"undefined"];

        
        NSLog(@"==>%@",dict);
        
        //集合操作
        IDLProduct *product1 = [IDLProduct new];
        product1.name = @"Product1";
        product1.price = 11;
        
        IDLProduct *product2 = [IDLProduct new];
        product2.name = @"Product2";
        product2.price = 12;
        
        IDLProduct *product3 = [IDLProduct new];
        product3.name = @"Product3";
        product3.price = 13;
        
        IDLProduct *product4 = [IDLProduct new];
        product4.name = @"Product4";
        product4.price = 14;
        
        IDLProduct *product5= [IDLProduct new];
        product5.name = @"Product5";
        product5.price = 15;
        
        NSArray<IDLProduct *> *products = @[product1,product2,product3,product4,product5];
        
        //基本集合操作
        NSInteger counts = [[products valueForKeyPath:@"@count"] integerValue];
        NSInteger sums = [[products valueForKeyPath:@"@sum.price"] integerValue];
        CGFloat avg = [[products valueForKeyPath:@"@avg.price"] floatValue];
        NSInteger max = [[products valueForKeyPath:@"@max.price"] integerValue];
        NSInteger min = [[products valueForKeyPath:@"@min.price"] integerValue];
        
        //对象集合操作
        NSArray *priceArray = [products valueForKeyPath:@"@unionOfObjects.price"];
        NSArray *nameArray = [products valueForKeyPath:@"@unionOfObjects.name"];
        NSInteger sumValue = [[priceArray valueForKeyPath:@"@sum.self"] integerValue];
        
        //全部调用某个方法
        nameArray = [nameArray valueForKeyPath:@"lowercaseString"];
        
        //数组集合操作
        NSArray *productArray = @[products,products,products,products];
        priceArray = [productArray valueForKeyPath:@"@unionOfArrays.price"];
        
        //其他用法
        NSArray *array = @[
                            @{@"name" : @"iPod",   @"price" : @99 },
                            @{@"name" : @"iPhone", @"price" : @199},
                            @{@"name" : @"iPhone", @"price" : @299},
                            @{@"name" : @"iPhone", @"price" : @299},
                        ];
        
        NSArray *collection = [array valueForKeyPath:@"name"];
        
        NSLog(@"");
        
    }
    return 0;
}

