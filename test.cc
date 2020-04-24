#include <stdio.h>
#include <string>

int main(){
    std::string a = "a";
    for (int i = 0; i < 3; i++)
    {
        a += "a";
    }
    
    printf("%shello\n", a.c_str());
    return 0;
}