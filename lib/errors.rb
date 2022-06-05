module Errors
  class Base < StandardError
    attr_accessor :errors

    def initialize(errors= [])
      @errors = errors
    end
  end

  class UnprocessableEntity < Base; end
end
