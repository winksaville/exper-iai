use iai::black_box;
use exper_iai::add;

fn iai_add() {
    black_box(add(2, 2));
}

iai::main!(iai_add,);
