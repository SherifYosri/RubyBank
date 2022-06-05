module AuthenticationHelper
  def add_auth_headers(user)
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
    request.headers.merge!(auth_headers)
  end
end