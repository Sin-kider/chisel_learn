#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VTOP.h"

VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;

static VTOP* TOP;

void step_and_dump_wave()
{
    TOP->eval();
    contextp->timeInc(1);
    tfp->dump(contextp->time());
}

void sim_init()
{
    contextp = new VerilatedContext;
    tfp = new VerilatedVcdC;
    TOP = new VTOP;
    contextp->traceEverOn(true);
    TOP->trace(tfp, 3);
    tfp->open("./wave.vcd");
}

void sim_exit()
{
    step_and_dump_wave();
    tfp->close();
}

int main() 
{ 
    sim_init();
    /***************  your code  ******************/
    
    /**********************************************/
    sim_exit();
}
