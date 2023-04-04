package main

import chisel3._
import chisel3.util._

class example(len: Int) extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(len.W))
    val out = Output(UInt(len.W))
  })
  io.out := io.in
}