# Experiment with iai

Experiment with [iai](https://github.com/bheisler/iai)

## Run:

```
$ cargo run
   Compiling exper_iai v0.1.0 (/home/wink/prgs/rust/myrepos/exper-iai)
    Finished dev [unoptimized + debuginfo] target(s) in 0.35s
     Running `target/debug/exper_iai`
6
$ cargo run --release
   Compiling exper_iai v0.1.0 (/home/wink/prgs/rust/myrepos/exper-iai)
    Finished release [optimized] target(s) in 0.18s
     Running `target/release/exper_iai`
6
```

## Asm code

The assembler code can be found at [/asm](/asm)
and is generated with [`./gen_asm.sh`](/gen_asm.sh).

If I look at the "asm" code there are 2 instructions in the `add` function:
```
$ cat -n asm/add.txt 
     1	.section .text.exper_iai::add,"ax",@progbits
     2		.globl	exper_iai::add
     3		.p2align	4, 0x90
     4		.type	exper_iai::add,@function
     5	exper_iai::add:
     6	
     7		.cfi_startproc
     8		lea rax, [rdi + rsi]
     9		ret
    10	
    11		.size	exper_iai::add, .Lfunc_end0-exper_iai::add
```

And `8` instructions in the `iai_add` function:
```
$ cat -n asm/iai_add.txt 
     1	.section .text.iai::iai_wrappers::iai_add,"ax",@progbits
     2		.p2align	4, 0x90
     3		.type	iai::iai_wrappers::iai_add,@function
     4	iai::iai_wrappers::iai_add:
     5	
     6		.cfi_startproc
     7		push rax
     8		.cfi_def_cfa_offset 16
     9	
    10		mov edi, 2
    11		mov esi, 2
    12		call qword ptr [rip + exper_iai::add@GOTPCREL]
    13		mov qword ptr [rsp], rax
    14	
    15		mov rax, qword ptr [rsp]
    16	
    17		pop rax
    18		.cfi_def_cfa_offset 8
    19		ret
    20	
    21		.size	iai::iai_wrappers::iai_add, .Lfunc_end5-iai::iai_wrappers::iai_add
```

So a plausible number of instructions is `10`.

## Benchmarks:

Significant difference between the `main` branch and this branch.

The `main` branch was:
```
bench_iai_add
  Instructions:                   8
```

For this branch it was:
```
iai_add
  Instructions:                  22
```

Here is the full output for `main` then this branch:
```
$ git switch main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
$ cargo clean
$ cargo bench
   Compiling autocfg v1.1.0
   Compiling proc-macro2 v1.0.47
...
   Compiling tinytemplate v1.2.1
   Compiling criterion v0.4.0
    Finished bench [optimized] target(s) in 20.07s
     Running unittests src/lib.rs (target/release/deps/exper_iai-e0c596df81667934)

running 1 test
test tests::it_works ... ignored

test result: ok. 0 passed; 0 failed; 1 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running unittests src/main.rs (target/release/deps/exper_iai-bbf641b3842b4eea)

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running benches/bench_iai.rs (target/release/deps/bench_iai-e75a6910d1576500)
bench_iai_add
  Instructions:                   8
  L1 Accesses:                   12
  L2 Accesses:                    2
  RAM Accesses:                   2
  Estimated Cycles:              92

$ git switch rename-bench_iai_add-to-iai-add 
Switched to branch 'rename-bench_iai_add-to-iai-add'
$ cargo clean
$ cargo bench
   Compiling autocfg v1.1.0
   Compiling proc-macro2 v1.0.47
...
   Compiling tinytemplate v1.2.1
   Compiling criterion v0.4.0
    Finished bench [optimized] target(s) in 20.06s
     Running unittests src/lib.rs (target/release/deps/exper_iai-e0c596df81667934)

running 1 test
test tests::it_works ... ignored

test result: ok. 0 passed; 0 failed; 1 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running unittests src/main.rs (target/release/deps/exper_iai-bbf641b3842b4eea)

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running benches/iai.rs (target/release/deps/iai-1d6df879cc9849e1)
iai_add
  Instructions:                  22
  L1 Accesses:                   34
  L2 Accesses:                    2
  RAM Accesses:                   2
  Estimated Cycles:             114
```

`taskset -c 0 cargo bench` for this branch:
```
$ taskset -c 0 cargo bench
    Finished bench [optimized] target(s) in 0.02s
     Running unittests src/lib.rs (target/release/deps/exper_iai-e0c596df81667934)

running 1 test
test tests::it_works ... ignored

test result: ok. 0 passed; 0 failed; 1 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running unittests src/main.rs (target/release/deps/exper_iai-bbf641b3842b4eea)

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s

     Running benches/iai.rs (target/release/deps/iai-1d6df879cc9849e1)
iai_add
  Instructions:                   0 (-100.0000%)
  L1 Accesses:                    0 (-100.0000%)
  L2 Accesses:                    1 (-50.00000%)
  RAM Accesses:                   2 (No change)
  Estimated Cycles:              75 (-34.21053%)
```



## License

Licensed under either of

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or http://apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the Apache-2.0 license, shall
be dual licensed as above, without any additional terms or conditions.
