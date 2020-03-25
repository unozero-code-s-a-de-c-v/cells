defmodule Rule30 do
    def stream(values) do
      Stream.resource(fn -> {values, 0} end, &next_fun/1, fn _ -> :ok end)
    end
  
    defp next_fun({values, layer}) do
      next = ([0, 0] ++ values ++ [0, 0])
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.map(&rule/1)
      {values |> Enum.map(&{layer, &1}), {next, layer + 1}}
    end
  
    defp rule([1, 1, 1]), do: 0
    defp rule([1, 1, 0]), do: 0
    defp rule([1, 0, 1]), do: 0
    defp rule([1, 0, 0]), do: 1
    defp rule([0, 1, 1]), do: 1
    defp rule([0, 1, 0]), do: 1
    defp rule([0, 0, 1]), do: 1
    defp rule([0, 0, 0]), do: 0
  end