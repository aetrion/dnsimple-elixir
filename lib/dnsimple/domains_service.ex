defmodule Dnsimple.DomainsService do
  @moduledoc """
  DomainsService handles communication with the domain related
  methods of the DNSimple API.

  See https://developer.dnsimple.com/v2/domains/
  """

  alias Dnsimple.Client
  alias Dnsimple.ListOptions
  alias Dnsimple.Response
  alias Dnsimple.Domain


  @doc """
  Lists the domains.

  See https://developer.dnsimple.com/v2/domains/#list
  """
  @spec domains(Client.t, String.t | integer) :: Response.t
  def domains(client, account_id, options \\ []) do
    {headers, opts} = Client.headers(options)
    Client.get(client, Client.versioned("/#{account_id}/domains"), headers, ListOptions.prepare(opts))
    |> Response.parse(Domain)
  end

  @doc """
  List all domains from the account. This function will automatically
  page through to the end of the list, returning all domain objects.
  """
  @spec all_domains(Client.t, String.t | integer, Keyword.t) :: [Domain.t]
  def all_domains(client, account_id, options \\ []) do
    new_options = Keyword.merge([page: 1], options)
    all_domains(client, account_id, new_options, [])
  end

  defp all_domains(client, account_id, options, domain_list) do
    {:ok, response} = domains(client, account_id, options)
    all_domains(client, account_id, Keyword.put(options, :page, options[:page] + 1), domain_list ++ response.data, response.pagination.total_pages - options[:page])
  end

  defp all_domains(_, _, _, domain_list, 0) do
    domain_list
  end
  defp all_domains(client, account_id, options, domain_list, _) do
    all_domains(client, account_id, options, domain_list)
  end

  @doc """
  Creates a new domain in the account.

  See https://developer.dnsimple.com/v2/domains/#create
  """
  @spec create_domain(Client.t, String.t | integer, map, Keyword.t) :: Response.t
  def create_domain(client, account_id, attributes, options \\ []) do
    {headers, opts} = Client.headers(options)
    Client.post(client, Client.versioned("/#{account_id}/domains"), attributes, headers, opts)
    |> Response.parse(Domain)
  end

  @doc """
  Get a domain.

  See https://developer.dnsimple.com/v2/domains/#get
  """
  @spec domain(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def domain(client, account_id, domain_id, options \\ []) do
    {headers, opts} = Client.headers(options)
    Client.get(client, Client.versioned("/#{account_id}/domains/#{domain_id}"), headers, opts)
    |> Response.parse(Domain)
  end

  @doc """
  PERMANENTLY deletes a domain from the account.

  See https://developer.dnsimple.com/v2/domains/#delete
  """
  @spec delete_domain(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def delete_domain(client, account_id, domain_id, options \\ []) do
    {headers, opts} = Client.headers(options)
    Client.delete(client, Client.versioned("/#{account_id}/domains/#{domain_id}"), headers, opts)
    |> Response.parse(nil)
  end

end
