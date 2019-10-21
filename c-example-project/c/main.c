//
// Created by taniguchi on 2019/10/16.
//

#include "greeting.h"

int main(int argc, char* argv[]) {
    greeting_t* greeting = create_Greeting("C Language");
    Hello(greeting, "C Language");
  
    return 0;
}
