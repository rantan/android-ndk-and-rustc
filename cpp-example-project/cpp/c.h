//
// Created by taniguchi on 2019/10/16.
//

#ifndef NDK_CROSSCOMPILE_C_H
#define NDK_CROSSCOMPILE_C_H

typedef struct greeting_t greeting_t;
greeting_t* create_Greeting(const char* name);
void call_Greeting_Hello(greeting_t* greeting, const char* hello);

#endif //NDK_CROSSCOMPILE_C_H
