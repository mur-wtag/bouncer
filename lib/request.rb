class PostRequest
  def initialize(url, body, auth_user, auth_pass)
    @url = url
    @body = body
    @user = auth_user
    @pass = auth_pass
  end

  def uri
    @uri ||= URI.parse @url
  end

  def http
    @http ||= Net::HTTP.new uri.host, uri.port
  end

  def submit
    req = Net::HTTP::Post.new(uri.request_uri)
    req.body = @body.to_json
    req['Content-Type'] = 'application/json'
    req.basic_auth @user, @pass
    http.request req
  end
end
