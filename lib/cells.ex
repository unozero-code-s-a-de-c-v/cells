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
@doc """
Convert Vector to Binary
## Examples
      iex> Cells.vec_to_binary(Cells.seedUnit())
      <<0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0>>
"""
  def vec_to_binary(v) do
    << v[0]:: 1,  v[1]:: 1,  v[2]:: 1,  v[3]:: 1,  v[4]:: 1,  v[5]:: 1,  v[6]:: 1,  v[7]:: 1,
       v[8]:: 1,  v[9]:: 1,  v[10]:: 1, v[11]:: 1, v[12]:: 1, v[13]:: 1, v[14]:: 1, v[15]:: 1,
       v[16]:: 1, v[17]:: 1, v[18]:: 1, v[19]:: 1, v[20]:: 1, v[21]:: 1, v[22]:: 1, v[23]:: 1,
       v[24]:: 1, v[25]:: 1, v[26]:: 1, v[27]:: 1, v[28]:: 1, v[29]:: 1, v[30]:: 1, v[31]:: 1,
       v[32]:: 1, v[33]:: 1, v[34]:: 1, v[35]:: 1, v[36]:: 1, v[37]:: 1, v[38]:: 1, v[39]:: 1,
       v[40]:: 1, v[41]:: 1, v[42]:: 1, v[43]:: 1, v[44]:: 1, v[45]:: 1, v[46]:: 1, v[47]:: 1,
       v[48]:: 1, v[49]:: 1, v[50]:: 1, v[51]:: 1, v[52]:: 1, v[53]:: 1, v[54]:: 1, v[55]:: 1,
       v[56]:: 1, v[57]:: 1, v[58]:: 1, v[59]:: 1, v[60]:: 1, v[61]:: 1, v[62]:: 1, v[63]:: 1,
       v[64]:: 1, v[65]:: 1, v[66]:: 1, v[67]:: 1, v[68]:: 1, v[69]:: 1, v[70]:: 1, v[71]:: 1,
       v[72]:: 1, v[73]:: 1, v[74]:: 1 ,v[75]:: 1, v[76]:: 1, v[77]:: 1, v[78]:: 1, v[79]:: 1,
       v[80]:: 1, v[81]:: 1, v[82]:: 1, v[83]:: 1, v[84]:: 1, v[85]:: 1, v[86]:: 1, v[87]:: 1,
       v[88]:: 1, v[89]:: 1, v[90]:: 1, v[91]:: 1, v[92]:: 1, v[93]:: 1, v[94]:: 1, v[95]:: 1,
       v[96]:: 1, v[97]:: 1, v[98]:: 1, v[99]:: 1, v[100]:: 1, v[101]:: 1, v[102]:: 1, v[103]:: 1,
       v[104]:: 1, v[105]:: 1, v[106]:: 1, v[107]:: 1, v[108]:: 1, v[109]:: 1, v[110]:: 1, v[111]:: 1,
       v[112]:: 1, v[113]:: 1, v[114]:: 1, v[115]:: 1, v[116]:: 1, v[117]:: 1, v[118]:: 1, v[119]:: 1,
       v[120]:: 1, v[121]:: 1, v[122]:: 1, v[123]:: 1, v[124]:: 1, v[125]:: 1, v[126]:: 1, v[127]:: 1>>
  end

  def binary_to_vec(b) do
    binary_list = :binary.bin_to_list b
    Vector.from_list(binary_list)
  end

  def binary_to_hex(b) do
    Base.encode16(b)
  end

  def rand(row) do
    Stream.iterate(sha30(row),fn i -> sha30(i) end)
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
    #IO.puts("Entropy: #{h} hamming_weight: #{hamming_weight}, num_bits: #{num_bits} prob_1:#{prob_1}, prob_0: #{prob_0}")
    h
  end


end
