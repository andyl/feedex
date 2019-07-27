defmodule RaggedClientTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock

  setup do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

  describe "#scan/1" do
    test "invalid resp invalid data" do
      use_cassette "scan_invalid_resp_invalid_data" do
        url_string = "https://zzz.reddit.com/z/elixir.rss"
        assert RaggedClient.scan(url_string) == {:error, "Bad URL"}
      end
    end

    test "valid resp invalid data" do
      use_cassette "scan_valid_resp_invalid_data" do 
        url_string = "https://www.reddit.com/r/elixir"
        assert RaggedClient.scan(url_string) == {:error, "Not an RSS feed"}
      end
    end

    test "valid resp valid data" do
      use_cassette "scan_valid_resp_valid_data" do 
        url_string = "https://www.reddit.com/r/elixir.rss"
        {status, url, _data} = RaggedClient.scan(url_string)
        assert status == :ok
        assert url == url_string
      end
    end
  end

  describe "#get/1" do
    test "invalid resp invalid data" do
      use_cassette "get_invalid_resp_invalid_data" do
        url_string = "https://zzz.reddit.com/z/elir.rss"
        assert RaggedClient.get(url_string) == {:error, "Bad URL"}
      end
    end

    test "valid resp invalid data" do
      use_cassette "get_valid_resp_invalid_data" do 
        url_string = "https://www.reddit.com/r/elixir"
        assert RaggedClient.get(url_string) == {:error, "Not an RSS feed"}
      end
    end

    test "valid resp valid data" do
      use_cassette "get_valid_resp_valid_data" do 
        url_string = "https://www.reddit.com/r/elixir.rss"
        {status, url, _data} = RaggedClient.get(url_string)
        assert status == :ok
        assert url == url_string
      end
    end
  end
end
