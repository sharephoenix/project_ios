//
//  OCFile.m
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/14.
//  Copyright © 2019 apple. All rights reserved.
//

#import "YSFile.h"
#import "TestCC.hpp"

@implementation YSFile

+ (int)sumWithNum:(int)a withNum:(int)b {
    TestCC c = TestCC();
    int sum = c.add(a, b);
    NSLog(@"%d", sum);
    return sum;
}

@end
