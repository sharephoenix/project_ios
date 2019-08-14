//
//  CPPerson.hpp
//  PhoenixiOS
//
//  Created by phoenix on 2019/8/13.
//  Copyright © 2019 apple. All rights reserved.
//

#ifndef CPPerson_hpp
#define CPPerson_hpp

#include <stdio.h>
#include <iostream>

using namespace std;

class CPPerson {
    string name;
    int age;
    bool isNan;
    
public:
    
    CPPerson();
    CPPerson(const char * name,int age, bool isNan);
    ~CPPerson();
    
    void printPersonInfo();
    const char* getPersonName();
    
};

#endif /* CPPerson_hpp */
