require Cells

Benchee.run(
      %{"sha30" => fn ->
        s = Cells.sha30(Cells.seedUnit)
        slist = Enum.to_list(s)
      end,
        "rand" => fn ->
        r = Cells.rand(Cells.seedUnit())
        s = Stream.take(r, 500)
        s_list = Enum.to_list(s)
       # h = Cells.entropy(s)
      end },
      formatters: [
        Benchee.Formatters.HTML,
        Benchee.Formatters.Console
      ]
    )
