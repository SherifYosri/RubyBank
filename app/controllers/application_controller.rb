require 'errors'

class ApplicationController < ActionController::API
  rescue_from ActionController::UnpermittedParameters, with: :unpermitted_params
  rescue_from ActionController::ParameterMissing, with: :missing_params
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
  rescue_from Errors::UnprocessableEntity, ActiveModel::ValidationError, with: :unprocessable_entity
  
  before_action :authenticate_user!
  
  def validate_params_presence!(required_params)
    required_params = Array.wrap required_params
    missing_params = []
    required_params.each { |p| missing_params << p unless params.has_key?(p) }
    
    raise ActionController::ParameterMissing.new(missing_params) unless missing_params.empty?
  end

  private

  def unpermitted_params(exception)
    error_message = "Unpermitted parameters"
    render json: errors_format(exception.params, error_message), status: :bad_request
  end

  def missing_params(exception)
    error_message = "Missing parameters"
    render json: errors_format(exception.param, error_message), status: :bad_request
  end

  def forbidden
    render json: errors_format(title: "Access Denied", detail: "Forbidden operation"), status: :forbidden
  end

  def not_found(exception)
    render json: errors_format(title: "Not found", detail: exception.message), status: :not_found
  end

  def invalid_record(exception)
    render json: exception.record, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
  end

  def unprocessable_entity(exception)
    if exception.is_a?(ActiveModel::ValidationError)
      render json: exception.model, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
    else
      render json: errors_format(exception.errors, "Unprocessable Entity"), status: :unprocessable_entity
    end
  end

  def errors_format(errors, title = nil)
    errors = Array.wrap(errors)
    errors_hash = { errors: errors.map!{ |error| error_format(error, title) } }

    errors_hash
  end

  def error_format(options, title)
    h = Hash.new
    if options.kind_of?(Hash)
      h[:title] = options[:title] if options[:title]
      h[:title] ||= title
      h[:detail] = options[:detail] if options[:detail]
    elsif options.kind_of?(String)
      h[:title] = title
      h[:detail] = options
    end

    h
  end
end
