require "net/http"
require "json"
require "open-uri"

class CustomSmsApi
  attr_accessor :client

  def initialize
    @client = Savon.client(wsdl: url)
  end
  
  def url
    return "" unless end_point_available?

    URI.parse(Tenant.current_secrets.sms_end_point).to_s
  end

  def authorization
    Base64.strict_encode64("#{Tenant.current_secrets.sms_username}:#{Tenant.current_secrets.sms_password}")
  end

  def sms_deliver(phone, code)
    puts "phone: #{phone}"
    return stubbed_response unless end_point_available?

    puts "url: #{url}"

    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)
    request.delete("accept-encoding")
    request.delete("accept")
    request.delete("user-agent")
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Basic #{authorization}"
    request.body = request_body(phone, code).to_json
    response = http.request(request)
    success?(response)
  end

  def request_body(phone, code)
    {
      to: [phone],
      from: "GobAbierto",
      message: "Clave para verificarte: #{code}. Ayuntamiento de San Lorenzo de El Escorial"
    }
  end

  def success?(response)
    json_response = JSON.parse(response.body)
    json_response["result"]&.first&.dig("accepted") == true
  end

  def end_point_available?
    Rails.env.staging? || Rails.env.preproduction? || Rails.env.production?
  end

  def stubbed_response
    {
      campaignId: 100000,
      sendingId: 100001,
      result: [
        {
          accepted: true,
          to: "34666555444",
          id: "XXXXXXXXXXXXX",
          parts: 1,
          scheduledAt: nil,
          expiresAt: nil
        }
      ]
    }
  end
end
