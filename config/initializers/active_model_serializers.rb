api_mime_types = %W(text/x-json application/json)

Mime::Type.register 'application/vnd.api+json', :json, api_mime_types

ActiveModelSerializers.config.adapter = :json_api
ActiveModelSerializers.config.key_transform = :underscore