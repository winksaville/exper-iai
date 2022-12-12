#!/usr/bin/env bash

# Enable error options
set -Eeuo pipefail

# Enable debug
#set -x

# Use `cargo asm --lib exper_iai` to see list of functions
gen_lib_asm () {
    #cargo asm --rust --lib "exper_iai::$1" > asm/$1.txt
    cargo asm --lib "exper_iai::$1" > asm/$1.txt
}

# Use `cargo asm --bin exper_iai` to see list of functions
gen_bin_asm () {
    #cargo asm --rust --bin exper_iai "exper_iai::$1" > asm/$1.txt
    cargo asm --bin exper_iai "exper_iai::$1" > asm/$1.txt
}

# Use `cargo asm --bench bench_iai` to see list of functions
gen_bench_iai_asm() {
    #cargo asm --rust --bench bench_iai "bench_iai::iai_wrappers::$1" > asm/$1.txt
    cargo asm --bench bench_iai "bench_iai::iai_wrappers::$1" > asm/$1.txt
}

gen_lib_asm "add"
gen_bin_asm "main"
gen_bench_iai_asm "bench_iai_add"
