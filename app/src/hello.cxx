#include <stdio.h>
#include <naothello.h>
#include "hello.h"
#include <list>
#include <algorithm>
#include <string>

namespace
{
    class MyClass
    {
    public:
        explicit MyClass() : _l{} {}
        MyClass(const MyClass &) = delete;
        MyClass &operator=(const MyClass &) = delete;
        MyClass(MyClass &&) = delete;
        MyClass &operator=(MyClass &&) = delete;
        void foo()
        {
            _l.push_back(42);
            _l.push_back(17);
        }

        std::string bar()
        {
            std::string s;
            std::for_each(_l.cbegin(), _l.cend(),
                          [&s](int i)
                          {
                              s += std::to_string(i);
                              s += " ";
                          });
            return s;
        }

    private:
        std::list<int> _l;
    };

    void cxx_Demo()
    {
        MyClass c{};
        c.foo();
        auto s = c.bar();
        printf("C++: %s\n", s.c_str());
    }

}

int hellolib_main(void)
{
    naot_Hello();
    cxx_Demo();
    printf("all done\n");
    return 0;
}
