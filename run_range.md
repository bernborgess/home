# Running programs in a range in bash

- Compiling program `a.cpp` and running for cases `1` to `20`:
  ```bash
  make a; for i in {1..20}; do echo "$i" | ./a; done
  ```
- Running against combinations of digits (AB in this case):
  ```bash
  i=3  # Replace with your desired length
  for n in $(seq 0 $((2**i - 1))); do 
      binary=$(echo "obase=2; $n" | bc | awk -v i="$i" '{printf "%0*d\n", i, $0}');
      echo "$binary" | tr '01' 'AB' | ./b;
  done
  ```
