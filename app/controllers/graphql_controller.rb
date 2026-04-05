# frozen_string_literal: true

class GraphqlController < ApplicationController
  before_action :require_authenticated_user!

  private

  def require_authenticated_user!
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end

  public

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = { current_user: current_user }
    result = PlutosSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  def prepare_variables(variables_param)
    case variables_param
    when String
      variables_param.present? ? JSON.parse(variables_param) || {} : {}
    when Hash, ActionController::Parameters
      variables_param.to_unsafe_hash
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render json: { errors: [ { message: e.message, backtrace: e.backtrace } ], data: {} }, status: :internal_server_error
  end
end
