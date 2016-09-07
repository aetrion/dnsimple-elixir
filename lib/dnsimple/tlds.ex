defmodule Dnsimple.Tlds do
  @moduledoc """
  This module provides functions to interact with the TLD related endpoints.

  See: https://developer.dnsimple.com/v2/tlds/
  """

  alias Dnsimple.List
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.Tld

  @doc """
  Lists the supported TLDs on DNSimple.

  See https://developer.dnsimple.com/v2/tlds/#list

  ## Examples

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Tlds.list_tlds(client)
    Dnsimple.Tlds.list_tlds(client, page: 2, per_page: 10)
    Dnsimple.Tlds.list_tlds(client, sort: "tlds:desc")

  """
  @spec list_tlds(Client.t, Keyword.t) :: Response.t
  def list_tlds(client, options \\ []) do
    url = Client.versioned("/tlds")

    List.get(client, url, options)
    |> Response.parse(Tld)
  end

  @spec tlds(Client.t, Keyword.t) :: Response.t
  defdelegate tlds(client, options \\ []), to: __MODULE__, as: :list_tlds


  @doc """
  Gets the information about a TLD.

  See https://developer.dnsimple.com/v2/tlds/#get

  ## Examples

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Tlds.get_tld(client, "com")

  """
  @spec get_tld(Client.t, String.t,  Keyword.t) :: Response.t
  def get_tld(client, tld, options \\ []) do
    url = Client.versioned("/tlds/#{tld}")

    Client.get(client, url, options)
    |> Response.parse(Tld)
  end

  @spec tld(Client.t, String.t, Keyword.t) :: Response.t
  defdelegate tld(client, tld, options \\ []), to: __MODULE__, as: :get_tld

end