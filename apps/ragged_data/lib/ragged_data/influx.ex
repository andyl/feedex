defmodule RaggedData.Influx do
  use Instream.Connection, otp_app: :ragged_data

  def write_point(measurement, fields, tags) do
    %{
      points: [
        %{
          measurement: measurement,
          fields: fields,
          tags: tags
        }
      ]
    } |> RaggedData.Influx.write()
  end
end
