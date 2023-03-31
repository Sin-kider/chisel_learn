#include <nvboard.h>
#include <VTOP.h>

static TOP_NAME TOP;

void nvboard_bind_all_pins(VTOP* TOP);

static void single_cycle() {
  TOP.clock = 0; TOP.eval();
  TOP.clock = 1; TOP.eval();
}

static void reset(int n) {
  TOP.reset = 1;
  while (n -- > 0) single_cycle();
  TOP.reset = 0;
}

int main() {
  nvboard_bind_all_pins(&TOP);
  nvboard_init();

  reset(10);

  while(1) {
    nvboard_update();
    single_cycle();
  }
}