defmodule SampleRunner do
  import ExProf.Macro

  @doc "analyze with profile macro"
  def do_analyze do
    profile do
      r = Cells.rand(Cells.seedUnit())
      s = Stream.take(r, 3)
      rlist = Enum.to_list(s)
      IO.puts("List length: #{Enum.count(rlist)}")
      
      Enum.map(rlist, fn x -> Cells.entropy(x) end)
    end
  end

  @doc "get analysis records and sum them up"
  def run do
    {records, _block_result} = do_analyze()
    total_percent = Enum.reduce(records, 0.0, &(&1.percent + &2))
    IO.inspect "total = #{total_percent}"
  end
end
