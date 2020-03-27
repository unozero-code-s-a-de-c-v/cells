defmodule SampleRunner do
  import ExProf.Macro

  @doc "analyze with profile macro"
  def do_analyze do
    profile do
       r = Stream.take(Cells.rand(Cells.seedUnit()),100)
       randlist = Enum.to_list(r)
       hexList = Enum.map(randlist, fn x ->
          "[<:#{Cells.vec_to_hex(x)}:>]"
       end)
        Enum.map(hexList, fn x -> IO.puts(x) end)
    end
  end

  @doc "get analysis records and sum them up"
  def run do
    {records, _block_result} = do_analyze()
    total_percent = Enum.reduce(records, 0.0, &(&1.percent + &2))
    IO.inspect "total = #{total_percent}"
  end
end

