
## Why `std::shared_ptr` Should Support Classes with Protected Destructors

**Author**: Davit Kalantaryan
**GitHub**: [https://github.com/davitkalantaryan](https://github.com/davitkalantaryan)

---

### The Problem

In modern C++, smart pointers like `std::shared_ptr` are essential for safe memory management. But there's an overlooked limitation: if a class has a **private or protected destructor**, and you want to manage its instances via `std::shared_ptr`, it **fails to compile** — even if `std::shared_ptr<T>` is declared as a `friend`.

Minimal example (fails on GCC, MSVC, and Clang):

```cpp
class TestClass {
    friend class ::std::shared_ptr<TestClass>;
protected:
    ~TestClass() = default;
public:
    TestClass() = default;
};

int main() {
    std::shared_ptr<TestClass> ptr(new TestClass());
    return 0;
}
```

All compilers report that `~TestClass()` is inaccessible.

---

### Why This Matters

In a large project of mine, we used `std::shared_ptr` extensively. After a short pause in development, I mistakenly deleted a pointer manually, forgetting it was managed by a shared pointer — which led to crashes.

To enforce stricter ownership, I tried protecting destructors, but the compiler errors blocked this. I then built a custom `shared_ptr`-like type that:

* Allows deletion when `shared_ptr<T>` is a declared friend
* Supports callbacks on **any reference count change** (not just when it drops to 0)

Implementation:

* [https://github.com/davitkalantaryan/cpputils/blob/master/include/cpputils/sharedptr.hpp](https://github.com/davitkalantaryan/cpputils/blob/master/include/cpputils/sharedptr.hpp)
* [https://github.com/davitkalantaryan/cpputils/blob/master/include/cpputils/sharedptr.impl.hpp](https://github.com/davitkalantaryan/cpputils/blob/master/include/cpputils/sharedptr.impl.hpp)

Demo of failing case:

* [https://github.com/davitkalantaryan/demo-cpputils](https://github.com/davitkalantaryan/demo-cpputils/blob/master/src/tests/main_std_shared_ptr_friend_error.cpp)

---

### Proposal Summary

I propose that `std::shared_ptr<T>` should delete objects directly, enabling friend access to `T`'s destructor. Additionally, the standard could optionally support reference count transition hooks, e.g.:

```cpp
using TypeClbk = std::function<void(void* clbkData, PtrType* pData, size_t refBefore, size_t refAfter)>;
```

This improves both safety and observability.

---

### Formal Proposal (DOCX)

I’ve prepared a formal WG21-style proposal document:

* [Download Proposal](https://github.com/user-attachments/files/20157741/SharedPtr_Proposal_DavitKalantaryan_FINAL_v2.docx)

---

### Feedback?

Before submitting this to WG21, I'd love feedback from the C++ community:

* Have you encountered this limitation?
* Would this benefit your team or project?
* Any concerns about ABI, implementation, or usability?

Looking forward to hearing your thoughts.

---

**License**: MIT
Demo and implementation code are public.
