use iai::black_box;
use exper_iai::add;

fn bench_iai_add() {
    black_box(add(2, 2));
}

iai::main!(bench_iai_add,);
