//
//  NSDictionary+Extension.m
//  xiaofu
//
//  Created by HNF's wife on 2016/12/18.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

- (NSString *)description {
    return [self descriptionWithLevel:1];
}

- (NSString *)descriptionWithLocale:(nullable id)locale {
    return [self descriptionWithLevel:1];
}
- (NSString *)descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    return [self descriptionWithLevel:(int)level];
}


/**
 将字典转化成字符串，文字格式UTF8,并且格式化
 
 @param level 当前字典的层级，最少为 1，代表最外层字典
 @return 格式化的字符串
 */
- (NSString *)descriptionWithLevel:(int)level {
    NSString *subSpace = [self getSpaceWithLevel:level];
    NSString *space = [self getSpaceWithLevel:level - 1];
    NSMutableString *retString = [[NSMutableString alloc] init];
    // 1、添加 {
    [retString appendString:[NSString stringWithFormat:@"{"]];
    // 2、添加 key = value;
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *value = (NSString *)obj;
            //value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            value = [value stringByRemovingPercentEncoding];
            NSString *subString = [NSString stringWithFormat:@"\n%@%@ = \"%@\";", subSpace, key, value];
            [retString appendString:subString];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)obj;
            NSString *str = [dic descriptionWithLevel:level + 1];
            str = [NSString stringWithFormat:@"\n%@%@ = %@;", subSpace, key, str];
            [retString appendString:str];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)obj;
            NSString *str = [arr descriptionWithLocale:nil indent:level + 1];
            str = [NSString stringWithFormat:@"\n%@%@ = %@;", subSpace, key, str];
            [retString appendString:str];
        } else {
            NSString *subString = [NSString stringWithFormat:@"\n%@%@ = %@;", subSpace, key, obj];
            [retString appendString:subString];
        }
    }];
    // 3、添加 }
    [retString appendString:[NSString stringWithFormat:@"\n%@}", space]];
    return retString;
}


/**
 根据层级，返回前面的空格占位符
 
 @param level 字典的层级
 @return 占位空格
 */
- (NSString *)getSpaceWithLevel:(int)level {
    NSMutableString *mustr = [[NSMutableString alloc] init];
    for (int i=0; i<level; i++) {
        [mustr appendString:@"\t"];
    }
    return mustr;
}

@end
