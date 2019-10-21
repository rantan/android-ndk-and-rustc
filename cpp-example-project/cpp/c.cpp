//
// Created by taniguchi on 2019/10/16.
//
#include "greeting.h"
#include <iostream>

extern "C" {

struct greeting_t {
    Greeting *rep;
};

greeting_t* create_Greeting(const char* name) {
    std::string name_str(name);
    Greeting* greeting = new Greeting(name_str);

    greeting_t* result = new greeting_t;
    result->rep = greeting;
    return result;
}

void call_Greeting_Hello(greeting_t* greeting, const char* hello) {
    std::string hello_str(hello);
    greeting->rep->Hello(hello_str);
}

}