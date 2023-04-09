import circt.stage._

object Elaborate extends App {
  def top       = new TOP()
  val generator = Seq(chisel3.stage.ChiselGeneratorAnnotation(() => top))
  (new chisel3.stage.ChiselStage).execute(args, generator)
}
