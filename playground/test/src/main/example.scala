package main

import chisel3._
import chiseltest._

import utest._


object example_test extends ChiselUtestTester {
  val tests = Tests {
    test("example_test") {
      testCircuit(new example(16)) { c =>
        for (input_data <- 0 to 65535) {
          c.io.in.poke(input_data.U)
          c.io.out.expect(input_data.U)
          c.clock.step()
        }
      }
    }
  }
}