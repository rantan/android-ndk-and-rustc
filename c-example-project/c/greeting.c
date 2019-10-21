//
// Created by taniguchi on 2019/10/16.
//
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "greeting.h"

struct greeting_t {
    char* name;
};

greeting_t* create_Greeting(const char* name) {
    struct greeting_t* result = malloc(sizeof *result);
    result->name = (char*)malloc(sizeof(char) * sizeof(name));
    strcpy(result->name, name);
    return result;
}

void Hello(greeting_t* greeting, const char* hello) {
    printf("Hello, %s from %s\n", greeting->name, hello);
}
