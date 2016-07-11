defmodule Dnsimple.RegistrarServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @service Dnsimple.RegistrarService
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}

  test ".check_domain" do
    fixture = "checkDomain/success.http"
    method  = "get"
    url     = "#{@client.base_url}/v2/1010/registrar/domains/example.com/check"

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
      {:ok, response} = @service.check_domain(@client, "1010", "example.com")

      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.DomainCheck
      assert response.data == %Dnsimple.DomainCheck{domain: "example.com", available: true, premium: false}
    end
  end

  test ".register_domain" do
    fixture     = "registerDomain/success.http"
    method      = "post"
    url         = "#{@client.base_url}/v2/1010/registrar/domains/example.com/registration"
    attributes  = %{registrant_id: 2, auto_renew: false, privacy: false}
    {:ok, body} = Poison.encode(attributes)

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
      {:ok, response} = @service.register_domain(@client, "1010", "example.com", attributes)

      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.Domain
      assert response.data == %Dnsimple.Domain{
        id: 1,
        name: "example.com",
        account_id: 1010,
        registrant_id: 2,
        auto_renew: false,
        private_whois: false,
        state: "registered",
        token: "cc8h1jP8bDLw5rXycL16k8BivcGiT6K9",
        created_at: "2016-01-16T16:08:50.649Z",
        updated_at: "2016-01-16T16:09:01.161Z",
        expires_on: "2017-01-16",
      }
    end
  end

  test ".renew_domain" do
    fixture     = "renewDomain/success.http"
    method      = "post"
    url         = "#{@client.base_url}/v2/1010/registrar/domains/example.com/renewal"
    attributes  = %{period: 3}
    {:ok, body} = Poison.encode(attributes)

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
      {:ok, response} = @service.renew_domain(@client, "1010", "example.com", attributes)

      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.Domain
      assert response.data == %Dnsimple.Domain{
        id: 1,
        name: "example.com",
        account_id: 1010,
        registrant_id: 2,
        auto_renew: false,
        private_whois: false,
        state: "registered",
        token: "domain-token",
        created_at: "2016-01-16T16:08:50.649Z",
        updated_at: "2016-02-15T15:19:24.689Z",
        expires_on: "2018-01-16",
      }
    end
  end

  test ".transfer_domain" do
    fixture     = "transferDomain/success.http"
    method      = "post"
    url         = "#{@client.base_url}/v2/1010/registrar/domains/example.com/transfer"
    attributes  = %{registrant_id: 10, auth_info: "x1y2z3", auto_renew: false, privacy: false}
    {:ok, body} = Poison.encode(attributes)

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
      {:ok, response} = @service.transfer_domain(@client, "1010", "example.com", attributes)

      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.Domain
      assert response.data == %Dnsimple.Domain{
        id: 1,
        name: "example.com",
        account_id: 1010,
        registrant_id: 10,
        auto_renew: false,
        private_whois: false,
        state: "hosted",
        token: "domain-token",
        created_at: "2016-02-21T13:31:58.745Z",
        updated_at: "2016-02-21T13:31:58.745Z",
        expires_on: nil,
      }
    end
  end

  test ".transfer_domain_out" do
    fixture     = "transferDomainOut/success.http"
    method      = "post"
    url         = "#{@client.base_url}/v2/1010/registrar/domains/example.com/transfer_out"
    attributes  = []
    {:ok, body} = Poison.encode(attributes)

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
      {:ok, response} = @service.transfer_domain_out(@client, "1010", "example.com")

      assert response.__struct__ == Dnsimple.Response
      assert is_nil(response.data)
    end
  end

end
