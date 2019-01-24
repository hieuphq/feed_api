defmodule DateHelper do
  import IntegerHelper

  def do_convert_date(nil), do: nil
  def do_convert_date([]), do: nil

  def do_convert_date(itms) when is_list(itms) do
    itms
    |> List.first()
    |> do_convert_date()
  end

  def do_convert_date(date_str) when is_binary(date_str) do
    captures =
      ~r/(?<year>\d+)-(?<month>\d+)-(?<day>\d+) (?<hour>\d+):(?<minute>\d+):(?<second>\d+) (?<time_zone_operator>[+-])(?<time_zone_hour>[0-9]+)(?<time_zone_minutes>[0-9]+)/
      |> Regex.named_captures(date_str)

    year = safe_to_integer(captures["year"])
    month = safe_to_integer(captures["month"])
    day = safe_to_integer(captures["day"])
    tz_hour = safe_to_integer(captures["time_zone_hour"])
    tz_minutes = safe_to_integer(captures["time_zone_minutes"])

    {time_zone, zone_abbr} =
      parse_timezone(
        captures["time_zone_operator"],
        year,
        month,
        day,
        tz_hour,
        tz_minutes
      )

    %DateTime{
      year: year,
      month: month,
      day: day,
      zone_abbr: zone_abbr,
      hour: safe_to_integer(captures["hour"]),
      minute: safe_to_integer(captures["minute"]),
      second: safe_to_integer(captures["second"]),
      microsecond: {0, 0},
      utc_offset: 0,
      std_offset: 0,
      time_zone: time_zone
    }
  end

  defp parse_timezone("+", year, month, day, tz_hour, tz_mins) do
    tz_final = make_timezone_float(tz_hour, tz_mins)
    tz = Timex.timezone(tz_final, {year, month, day})
    {tz.full_name, tz.abbreviation}
  end

  defp parse_timezone("-", year, month, day, tz_hour, tz_mins) do
    tz_final = make_timezone_float(tz_hour, tz_mins) * -1
    tz = Timex.timezone(tz_final, {year, month, day})
    {tz.full_name, tz.abbreviation}
  end

  defp make_timezone_float(hour, 0), do: hour

  defp make_timezone_float(hour, minutes) do
    hour * 1.0 + minutes / 60.0
  end
end
