defmodule CellsTest do
  use ExUnit.Case

  doctest Cells

  test "greets the world" do
    assert Cells.hello() == :world
  end

  test "seed block" do
    seed_block = Cells.seedUnit()
    assert Enum.at(seed_block, 63) == 1
    for i <- 0..62 do
      assert Enum.at(seed_block, i) == 0
    end
  end

  test "eval block" do
    eval_row = Cells.evalRow(Cells.seedUnit())
    for i <- 0..61 do
      assert Enum.at(eval_row, i) == 0
    end
    assert Enum.at(eval_row, 62) == 1
    assert Enum.at(eval_row, 63) == 1
    assert Enum.at(eval_row, 64) == 1
    for i <- 65..127 do
      assert Enum.at(eval_row, i) == 0
    end
  end

  test "eval field" do
    s = Cells.evalField(Cells.seedUnit())
    t = Stream.take(s, 128)
    tl = Enum.to_list(t)
    assert Enum.count(tl) == 128
    IO.puts("")
    Enum.map(tl, fn
      n -> IO.puts("#{n}")
    end)
  end

  test "sha30" do
     # "evalblock(seedUnit) should return 101110011000101100100.."
    s = Cells.sha30(Cells.seedUnit())
    IO.puts("SHA30 test")
    sl = Enum.to_list(s)
    IO.puts("Sha30 test:")
    IO.inspect(sl)
    assert Enum.count(sl) == 128

  end

  test "rand" do
    r = Cells.rand(Cells.seedUnit())
    s = Stream.take(r, 2)
    s0 = Enum.at(s,0)
    assert Enum.count(s0) == 128
    s1 = Enum.at(s,1)
    assert Enum.count(s1) == 128
    IO.puts("S0")
    IO.inspect(s0)
    IO.puts("S1")
    IO.inspect(s1)
    all_bits = Enum.flat_map(s, fn x -> x end)
    IO.puts("Flatmap #{Enum.count(all_bits)} bits")

    h = Cells.entropy(all_bits)
    IO.puts("Entropy: #{h}")
    assert(h > 0.99)
  end

end
