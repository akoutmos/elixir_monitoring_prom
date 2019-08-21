wait_time_per_query_ms = 75
number_of_queries = 1..10_000
miles_to_search = 1..50

valid_zips =
  "#{__DIR__}/priv/repo/wa_zip_codes.csv"
  |> File.read!()
  |> String.split("\n")
  |> Enum.filter(fn line -> String.trim(line) != "" end)
  |> Enum.map(fn csv_line ->
    [zip, _city, _state, _lat, _long, _tz, _dst] =
      csv_line
      |> String.replace("\"", "")
      |> String.replace("\n", "")
      |> String.split(",")

    zip
  end)

:inets.start()

Enum.each(number_of_queries, fn count ->
  radius = Enum.random(miles_to_search)
  zip = Enum.random(valid_zips)

  url =
    String.to_charlist(
      "http://localhost:4000/api/breweries?zip_code=#{zip}&mile_radius=#{radius}"
    )

  :httpc.request(:get, {url, []}, [], [])

  if rem(count, 100) == 0, do: IO.puts("Made #{count} zip code requests")

  :timer.sleep(wait_time_per_query_ms)
end)
