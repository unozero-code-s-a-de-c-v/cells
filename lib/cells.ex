defmodule Cells do
  use Tensor

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
    stream_seed = Stream.unfold(0, fn
      128 -> nil
      63  -> {1, 64}
      n   -> {0, n+1}
    end)
    list_seed = Enum.to_list(stream_seed)

    Vector.from_list(list_seed)
  end

  def triplet(row, index) do
    case index do
      0   -> {row[127], row[0], row[1]}
      127 -> {row[126],  row[127], row[0]}
      n   -> {row[n-1], row[n], row[n+1]}
    end
  end

  #  Rule 30 : A XOR (B OR C)
  #  x(n+1,i) = x(n,i-1) xor [x(n,i) or x(n,i+1)]

  def r30(three) do
    case three do
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
    eval_list = for n <- 0..127, do: r30(triplet(row,n))
    Vector.from_list(eval_list)
  end

  def evalField(row) do
     stream_field = Stream.unfold(row, fn
        r -> {r, evalRow(r)}
     end)

     stream_field # stream of List of vectors
  end

  def sha30(row) do
    sf = Stream.take(Stream.drop(evalField(row), 128), 128)
    sfl = Enum.to_list(sf)
    m = Matrix.from_rows(sfl)
    Matrix.column(m,63)
  end

  def nibble_to_hex(nibble) do
    cond do
      {0,0,0,0} == nibble -> '0'
      {0,0,0,1} == nibble -> '1'
      {0,0,1,0} == nibble -> '2'
      {0,0,1,1} == nibble -> '3'
      {0,1,0,0} == nibble -> '4'
      {0,1,0,1} == nibble -> '5'
      {0,1,1,0} == nibble -> '6'
      {0,1,1,1} == nibble -> '7'
      {1,0,0,0} == nibble -> '8'
      {1,0,0,1} == nibble -> '9'
      {1,0,1,0} == nibble -> 'A'
      {1,0,1,1} == nibble -> 'B'
      {1,1,0,0} == nibble -> 'C'
      {1,1,0,1} == nibble -> 'D'
      {1,1,1,0} == nibble -> 'E'
      {1,1,1,1} == nibble -> 'F'
    end
  end

  def vec_to_hex(v) do
    nibbles = Stream.chunk_every(v, 4)
    nibble_hex = Stream.map(nibbles, fn
      [s0,s1,s2,s3] -> nibble_to_hex({s0,s1,s2,s3})
    end )
    Enum.join(nibble_hex)
  end

  def rand(row) do
    Stream.iterate(sha30(row),fn i -> sha30(i) end)
  end

  defp hamming_block(block) do
    Enum.reduce(block, 0, fn bit, acc -> acc + bit end)
  end

  def entropy(v) do
    num_bits= Vector.length(v)
    hamming_weight = Enum.reduce(v, 0, fn x,acc -> acc + x end)

    prob_1 = hamming_weight / num_bits
    prob_0 = 1.0 - prob_1

    h = if (prob_1 == 0.0 ) || (prob_0 == 0.0)  do
      0
    else
      0.0 -  (prob_1 * ElixirMath.log2(prob_1) + prob_0 * ElixirMath.log2(prob_0))
    end
    IO.puts("Entropy: #{h} hamming_weight: #{hamming_weight}, num_bits: #{num_bits} prob_1:#{prob_1}, prob_0: #{prob_0}")
    h
  end


end
