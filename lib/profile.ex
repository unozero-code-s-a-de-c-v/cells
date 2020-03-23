defmodule Profile do
  import ExProf.Macro

  def go do
    :fprof.apply(&run_test/0, [])
    :fprof.profile()
    :fprof.analyse()
  end 
  
  def run_test do
    r = Cells.rand(Cells.seedUnit())
    s = Stream.take(r, 2)
    slist = Enum.to_list(s)

  end
  
end