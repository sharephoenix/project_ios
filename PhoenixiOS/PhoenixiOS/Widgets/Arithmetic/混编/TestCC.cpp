//
//  CCFile.cpp
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/14.
//  Copyright © 2019 apple. All rights reserved.
//

#include "TestCC.hpp"

int TestCC::add(int a, int b) {
    return a + b;
}

TestCC::~TestCC() {
    cout << "delloc";
}
