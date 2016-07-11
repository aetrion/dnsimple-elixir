defmodule Dnsimple.Certificate do
  @moduledoc """
  Represents a [DNSimple certificate](https://developer.dnsimple.com/v2/certificates/#certificate-attributes)
  """

  @fields [
    :id, :domain_id,
    :name, :common_name,
    :years, :csr, :state,
    :authority_identifier,
    :expires_on, :created_at, :updated_at
  ]

  @type t :: %__MODULE__{
    id: integer, domain_id: integer,
    name: String.t, common_name: String.t,
    years: integer, csr: String.t, state: String.t,
    authority_identifier: String.t,
    expires_on: String.t, created_at: String.t, updated_at: String.t
  }

  defstruct @fields

end
