## Why `std::shared_ptr` Should Support Classes with Protected Destructors

**Author:** Davit Kalantaryan  
**GitHub:** [https://github.com/davitkalantaryan](https://github.com/davitkalantaryan)

---

### The Problem

C++ developers rely on `std::shared_ptr` for safe and automatic memory management. However, a hidden limitation affects its usability in clean, encapsulated designs: if a class has a **protected or private destructor**, and you declare `std::shared_ptr<T>` as a `friend`, you would expect it to work.

It doesn’t.

Despite granting friendship, the destruction fails at compile time because the actual deletion is performed by an internal type or lambda that is *not* a friend of the class. This behavior is consistent across GCC, Clang, and MSVC.

Here’s a minimal example:

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

This results in compiler errors stating the destructor is inaccessible.

---

### Why This Matters

In a large production system I developed, we relied heavily on `std::shared_ptr` for memory management. After a short break in development, I mistakenly deleted a pointer manually — forgetting it was owned by a shared pointer. The result: subtle crashes and time-consuming debugging.

To avoid such mistakes, I decided to enforce smart pointer-only ownership by making destructors protected. Unfortunately, standard `shared_ptr` made this impossible.

---

### My Workaround: A Smarter Smart Pointer

To address the issue, I created a custom `shared_ptr`-like implementation that:

* Properly supports friend-deletion of objects with protected/private destructors.
* Adds support for **reference count change notifications** — allowing advanced diagnostics or memory tracking.

GitHub links:

* Implementation: [sharedptr.hpp](https://github.com/davitkalantaryan/cpputils/blob/master/include/cpputils/sharedptr.hpp)
* Failing demo: [demo-cpputils](https://github.com/davitkalantaryan/demo-cpputils)

---

### What I Propose

1. Require `std::shared_ptr<T>` to handle deletion directly in its own scope (so `friend class std::shared_ptr<T>` is meaningful).
2. Optionally, extend `shared_ptr` to support callbacks on reference count changes. For example:

```cpp
using TypeClbk = std::function<void(void* clbkData, PtrType* pData, size_t refBefore, size_t refAfter)>;
```

---

### Formal Proposal

I’ve prepared a full WG21-style proposal:
[📄 Download the DOCX proposal](https://github.com/user-attachments/files/20157741/SharedPtr_Proposal_DavitKalantaryan_FINAL_v2.docx)

---

### I’m Looking for Feedback

* Have you run into this limitation in your work?
* Would this help simplify and protect ownership models in your projects?
* Do you foresee risks with this change?

Feel free to comment or reach out on GitHub. I’m also in the process of contacting WG21 members for feedback and sponsorship.

---

Let me know if you'd like a headline or summary version too (e.g., for sharing the article post on your LinkedIn feed).
