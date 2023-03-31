import chisel3._
import chiseltest._
import chisel3.util._
import chisel3.experimental.BundleLiterals._
import utest._
import main.TOP

object TOPtest extends ChiselUtestTester {
    val tests = Tests {
        test("TOP") {
            testCircuit(new TOP()) { c => 
                for (a <- 0 to 65535) {
                    c.io.sw.poke(a.U(16.W))
                    c.io.ledr.expect(a.U(16.W))
                    c.clock.step()
                }
            }
        }
    }
}