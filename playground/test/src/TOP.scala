import chisel3._
import chiseltest._
import chisel3.experimental.BundleLiterals._

import utest._


object TOPtest extends ChiselUtestTester {
  val tests = Tests {
    test("TOP") {
      testCircuit(new TOP()) { c =>
        for (input_data <- 0 to 65535) {
          c.io.sw.poke(input_data.U)
          c.io.ledr.expect(input_data.U)
          c.clock.step()
        }
      }
    }
  }
}