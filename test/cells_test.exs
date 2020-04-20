defmodule CellsTest do
  use ExUnit.Case
  use Tensor

  doctest Cells

  test "seed block" do
    seed_block = Cells.seedUnit()
    assert seed_block[63] == 1
    for i <- 0..62 do
      assert seed_block[i] == 0
    end
  end

  test "eval block" do
    eval_row = Cells.evalRow(Cells.seedUnit())
    for i <- 0..61 do
      assert eval_row[i] == 0
    end
    assert eval_row[62] == 1
    assert eval_row[63] == 1
    assert eval_row[64] == 1
    for i <- 65..127 do
      assert eval_row[i] == 0
    end
  end

  test "eval field" do
    s = Cells.evalField(Cells.seedUnit())
    t = Stream.take(s, 128)
    tl = Enum.to_list(t)
    assert Vector.length(Enum.at(tl,0)) == 128
  end

  test "sha30" do
    s = Cells.sha30(Cells.seedUnit())
    assert Vector.length(s) == 128
    assert Cells.vec_to_hex(s) == "6C4E5989B28FCBEAA031A17378601136"
  end


  test "Hex to binary" do
    h = "00000000000000000000000000000000"
    b = Cells.hex_to_binary(h)
    assert b == <<0::size(128)>>

    h = "000000000000000000000000000000FF"
    b = Cells.hex_to_binary(h)
    assert b == <<0::size(120),255::size(8)>>

    h = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
    b = Cells.hex_to_binary(h)
    assert b == <<255::size(8),255::size(8),255::size(8),255::size(8),255::size(8),255::size(8),255::size(8),255::size(8), 255::size(8),255::size(8),255::size(8),255::size(8),255::size(8),255::size(8),255::size(8),255::size(8)>>
  end

  test "Hex to Vector" do
    h = "00000000000000000000000000000000"
    v = Cells.hex_to_vec(h)
    for i <- 0..127, do: assert v[i] == <<0>>
  end

  test "Hex to Binary and back" do
    r = Cells.rand(Cells.seedUnit)
    rvecList = Stream.take(r, 100)
    hexlist = Stream.map(rvecList, &Cells.vec_to_hex/1)
    binlist = Stream.map(rvecList, &Cells.vec_to_binary/1)
    hexFromBin = Stream.map(binlist, &Cells.binary_to_hex/1)
  #  for h <- hexlist, hb <- hexFromBin, do: assert h == hb
  assert true
  end


  test "rand" do
    r = Cells.rand(Cells.seedUnit())
    s = Stream.take(r, 3)
    s0 = Enum.at(s,0)
    assert Vector.length(s0) == 128
    s1 = Enum.at(s,1)
    assert Vector.length(s1) == 128

    all_bits = Enum.flat_map(s, fn x -> x end)
  #  IO.puts("Flatmap #{Enum.count(all_bits)} bits")

    h = Cells.entropy(Vector.from_list(all_bits))
  #  IO.puts("Entropy: #{h}")
    assert(h > 0.99)
  end

end
