defmodule Cells do
  @gridDim %{:x => 128, :y => 128}
  @moduledoc """
  Documentation for Cells.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Cells.hello()
      :world

  """
  def hello do
    :world
  end

  def seedUnit() do
    Stream.unfold(0, fn
      128       -> nil
      63        -> {1, 64}
      n         -> {0, n+1}
    end) |> Enum.to_list
  end

  def triplet(row, index) do
    case index do
      0   -> {Enum.at(row, 127), Enum.at(row, 0), Enum.at(row, 1)}
      127 -> {Enum.at(row, 126),  Enum.at(row, 127), Enum.at(row, 0)}
      n   -> {Enum.at(row, n-1), Enum.at(row, n), Enum.at(row, n+1)}
    end
  end

  #  Rule 30 : A XOR (B OR C)
  #  x(n+1,i) = x(n,i-1) xor [x(n,i) or x(n,i+1)]

  def r30(triplet) do
    case triplet do
        {0,0,0} -> 0
        {0,0,1} -> 1
        {0,1,0} -> 1
        {0,1,1} -> 1
        {1,0,0} -> 1
        {1,0,1} -> 0
        {1,1,0} -> 0
        {1,1,1} -> 0
    end
  end

  def evalRow(row) do
    Enum.map(0..127, fn i -> r30(triplet(row, i)) end)
  end

  def evalField(row) do
     Stream.unfold(row, fn
       r -> {r, evalRow(r)}
     end)
  end

  def sha30(row) do
    s = Stream.take(Stream.drop(evalField(row), 128), 128)
    center = Stream.map(s, fn i ->
      Enum.at(i,63) end)
   center
  end

  def rand(row) do
    r = Enum.to_list(sha30(row))
    Stream.iterate(r, &sha30/1)
  #    Stream.unfold(row, fn
  #    m ->  r = sha30(m)
  #      { r, sha30(r)}
  #  end)
  end

  defp hamming_block(block) do
    Enum.reduce(block, 0, fn bit, acc -> acc + bit end)
  end

  def entropy(data) do
    num_bits= Enum.count(data)
    hamming_weight = Enum.reduce(data, 0, fn x,acc -> acc + x end)

    prob_1 = hamming_weight / num_bits
    prob_0 = 1.0 - prob_1
    IO.puts("Entropy: hamming_weight: #{hamming_weight}, num_bits: #{num_bits} prob_1:#{prob_1}, prob_0: #{prob_0}")
    if (prob_1 == 0.0 ) || (prob_0 == 0.0)  do
      0
    else
      0.0 -  (prob_1 * ElixirMath.log2(prob_1) + prob_0 * ElixirMath.log2(prob_0))
    end
  end


end
