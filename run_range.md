# Running programs in a range in bash

- Compiling program `a.cpp` and running for cases `1` to `20`:
  ```bash
  make a; for i in {1..20}; do echo "$i" | ./a; done
  ```
