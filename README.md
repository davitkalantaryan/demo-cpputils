## Why `std::shared_ptr` Should Support Classes with Protected Destructors

**Author:** Davit Kalantaryan
**GitHub:** [github.com/davitkalantaryan](https://github.com/davitkalantaryan)

---

### 🧩 The Problem

In modern C++, smart pointers like `std::shared_ptr` are essential tools for automatic memory management and safety. However, there's a hidden limitation: if a class has a **private or protected destructor**, and you want to manage its instances via `std::shared_ptr`, you **cannot do so** — even if you explicitly declare `std::shared_ptr<T>` as a `friend`.

Here’s an example that fails to compile on **GCC**, **MSVC**, and **Clang**:

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

All three major compilers will report errors indicating that `~TestClass()` is inaccessible.

### 🧵 Why This Matters

In one of my large-scale C++ projects, I relied on `std::shared_ptr` to manage all major system objects. After returning from a break, I mistakenly deleted a raw pointer manually — forgetting it was managed by a smart pointer. This led to crashes and undefined behavior.

To prevent such risks, I attempted to make destructors `protected` and enforce `shared_ptr`-only ownership. Unfortunately, the compiler errors prevented this. As a workaround, I had to implement my own `shared_ptr`-like class that could:

* Delete objects even with protected/private destructors (if declared friend)
* Register callbacks on **any reference count change**, not just when it hits zero

You can find that implementation here:

* [sharedptr.hpp](https://github.com/davitkalantaryan/cpputils/blob/master/include/cpputils/sharedptr.hpp)
* [sharedptr.impl.hpp](https://github.com/davitkalantaryan/cpputils/blob/master/include/cpputils/sharedptr.impl.hpp)

### 🧪 Demonstration

To show the failure clearly, I created a separate repository with code that reproduces the issue:

* [Demo (fails to compile)](https://github.com/davitkalantaryan/demo-cpputils)

This is not a corner case. It can and does happen in real projects — especially when teams grow and enforce stricter ownership models.

### 💡 The Proposal

I propose that the standard require `std::shared_ptr<T>` to perform deletion directly — from within `shared_ptr<T>` itself — so that declaring it a `friend` gives access to the destructor.

In addition, I'd like to propose an optional mechanism to observe **reference count transitions**, like:

```cpp
using TypeClbk = std::function<void(void* clbkData, PtrType* pData, size_t refBefore, size_t refAfter)>;
```

This gives more transparency and diagnostic power for advanced scenarios (e.g., GUIs, data tracking).

### 📄 Full Proposal Document

I have prepared a formal proposal suitable for submission to WG21:

* [📄 Download DOCX Proposal](https://github.com/davitkalantaryan/demo-cpputils/releases)

### 🧭 Publishing Channels

This article is published across:

* [LinkedIn Article](#)
* [Medium Blog](#)
* [Reddit Post in r/cpp](#)
* [GitHub README](https://github.com/davitkalantaryan/demo-cpputils)

### 🙏 Feedback Welcome

Before I take this to WG21, I’d appreciate any input:

* Have you run into similar limitations?
* Does this sound useful for safety in your projects?
* Would your team benefit from observing refcount transitions?

Let’s discuss! You can reach me on GitHub or comment on any of the platforms above.

---

**License:** MIT
**All demo and implementation code is publicly available.**
