module SerializationHelper
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def data
    json_response[:data]
  end

  def errors
    json_response[:errors]
  end
end   