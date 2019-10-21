//
// Created by taniguchi on 2019/10/16.
//

#include "greeting.h"
#include <iostream>

Greeting::Greeting(std::string name): name(name) {}

void Greeting::Hello(std::string hello) {
    std::cout << "Hello, " << name << " from " << hello << std::endl;
}