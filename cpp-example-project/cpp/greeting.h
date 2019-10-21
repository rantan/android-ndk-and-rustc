//
// Created by taniguchi on 2019/10/16.
//

#ifndef NDK_CROSSCOMPILE_GREETING_H
#define NDK_CROSSCOMPILE_GREETING_H

#include <string>

class Greeting {
private:
    std::string name;
public:
    Greeting(std::string name);
    void Hello(std::string hello);
};


#endif //NDK_CROSSCOMPILE_GREETING_H
