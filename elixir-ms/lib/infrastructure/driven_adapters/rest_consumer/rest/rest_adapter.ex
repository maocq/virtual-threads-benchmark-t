defmodule ElixirMs.Infrastructure.Adapters.RestConsumer.Rest.RestAdapter do
  alias ElixirMs.Config.ConfigHolder
  #alias ElixirMs.Domain.Model.Rest

  def hello(latency) do
    %{ external_service_ip: external_service_ip } = ConfigHolder.conf()
    url = "http://#{external_service_ip}:3100/#{latency}"

    case Finch.build(:get, url) |> Finch.request(HttpFinch) do
      {:ok, %Finch.Response{body: body}} -> {:ok, body}
      error -> error
    end
  end
end
