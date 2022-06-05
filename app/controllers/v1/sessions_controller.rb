module V1
  class SessionsController < Devise::SessionsController
    respond_to :json
    
    private
    
    def respond_with(resource, _opts = {})
      render json: resource
    end
  end
end
