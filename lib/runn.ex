defmodule Runn do
 
  
 
    def do_run do
   
        r = Cells.rand(Cells.seedUnit())
       
      s = Stream.take(r, 3)
      rlist = Enum.to_list(s)
         IO.puts("List length: #{Enum.count(rlist)}")
        IO.inspect(rlist)
        #Enum.map(rlist, fn x -> IO.puts("X: #{x}") end)
    
    end
  
    
  end