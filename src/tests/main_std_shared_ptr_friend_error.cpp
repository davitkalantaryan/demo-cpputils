//
// repo:			cpputilsdemo
// file:            main_std_shared_ptr_friend_error.cpp
// path:			src/tests/main_std_shared_ptr_friend_error.cpp
// created on:		2025 May 05
// created by:		Davit Kalantaryan (davit.kalantaryan@desy.de)
//


#include <memory>

#ifndef CPPUTILS_VISIBILITY
#define CPPUTILS_VISIBILITY  private
#endif

class TestClass
{
CPPUTILS_VISIBILITY:
    friend class ::std::shared_ptr<TestClass>;
    ~TestClass() = default;
public:
    TestClass() = default;
};

int main(int a_argc, char* a_argv[])
{
    static_cast<void>(a_argc);
    static_cast<void>(a_argv);

    ::std::shared_ptr<TestClass> smrtPtr(new TestClass());

    return 0;
}
