**Why `std::shared_ptr` Should Support Classes with Protected Destructors**

Author: Davit Kalantaryan
GitHub: [https://github.com/davitkalantaryan](https://github.com/davitkalantaryan)

---

**The Problem**

In modern C++, smart pointers like `std::shared_ptr` are essential for safe memory management. But there's a limitation: if a class has a *private or protected destructor*, and you try to manage it with `std::shared_ptr`, it fails to compile — even if `std::shared_ptr<T>` is a `friend`.

This behavior is consistent across GCC, MSVC, and Clang.

Example:

```
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

---

**Why This Matters**

In a production system I built, I used `std::shared_ptr` to manage ownership everywhere. After returning from a break, I forgot one pointer was managed by a shared pointer — deleted it manually — and caused serious runtime crashes.

I tried to protect the destructor to enforce safety, but compilers wouldn't allow it. So I built my own smart pointer that:

* Allows destruction when `shared_ptr<T>` is a friend
* Supports callbacks on *any* reference count change

---

**Demo and Fix**

Failing example:
[demo-cpputils](https://github.com/davitkalantaryan/demo-cpputils/blob/master/src/tests/main_std_shared_ptr_friend_error.cpp)

My implementation:
[sharedptr.hpp](https://github.com/davitkalantaryan/cpputils/blob/master/include/cpputils/sharedptr.hpp)
[sharedptr.impl.hpp](https://github.com/davitkalantaryan/cpputils/blob/master/include/cpputils/sharedptr.impl.hpp)

---

**Proposal Summary**

* Fix `std::shared_ptr` so that it deletes objects directly.
* Add optional hooks for refcount tracking:

  ```
    using TypeClbk = std::function<void(void* clbkData, PtrType* pData, size_t refBefore, size_t refAfter)>;
  ```

---

**Full Proposal Document**
[https://github.com/user-attachments/files/20157741/SharedPtr\_Proposal\_DavitKalantaryan\_FINAL\_v2.docx](https://github.com/user-attachments/files/20157741/SharedPtr_Proposal_DavitKalantaryan_FINAL_v2.docx)

---

**Looking for Feedback:**

* Have you hit this limitation?
* Would this proposal help in your team?
* Any drawbacks you see?

Thanks for reading.
