Notes
=====

- Fortran follows C / C++ model
- Jargon:
  - Bound procedures = methods
  - type / exactly that type
  - `class` polymorphic type or template
- `select type` construct is like `isinstance` + `if-else` in Python
- unlimited polymorphic type is like a placeholder. Similar to `void *` pointer
- `type is (integer)`, kind syntax: `type is (integer(2))`.
- Procedure self argument uses `class` and not `type`. It allows extended
  classes. If `type` is used, then `procedure, nopass` must be used and the
  object has to be passed explicitly in the argument list.


Pointers and allocatables
--------------------------
- Use `allocatable` when possible, no memory leaks
- Pointers for non contiguous part of ano array `p => array(1:10:2,2:30:4)`.
  Use `associate` if the logic is local not needs to be passed around.
- Pointers carry a lot of info in Fortran, contains the extent of the data
  (start and end).
- Downsides: no ptr arithmetic, cannot convert typed pointers to another type.
  Have to use unlimited polymorphic variables.
- Avoid if you can, but lot safer than C or C++.


Derived types and Software patterns
-----------------------------------
- `type ... end type`: no constructors or logic executation at instantiation.
  Can specify default values.
- Gives: initializer (RHS, default values), copy function and vtable. Can be
  seen in godbolt.
- `-S -fverbose-asm`
- No function call in default initializer.
- If a constructor is defined, there will be a function call, unless link time
  optimization (LTO) is used - `-flto` would inline initialization function
- Examples:
  - Iterators: similar to `next` in Python
  - Commannd: Separation of operation and data operated on. Like a task queue.


Advanced
--------
- Abstract: similar to ABC (abstract base classes) in Python
- ordinary derived types can have abstract interfaces too.
- final: finalizers are like __exit__ in Python or destructors in C++
- generic: single dispatch
- non_overridable: "protected" from being redefined by child classes
- routines can be classed via procedure pointers or fixed names. Allows both
  OOP or plain subroutine calls.
- no multiple inheritance allowed.

