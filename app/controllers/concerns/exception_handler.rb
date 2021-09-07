module ExceptionHandler
  extend Response
  extend ActiveSupport::Concern
  included do

    # rescue_from ActiveRecord::RecordNotFound do |e|
    #   render json:
    #     {
    #       errors:
    #       [
    #         {
    #           status: e.status,
    #           message: e.message,
    #           code: e.code
    #         }
    #       ]
    #     }
    # end

    # rescue_from ActiveRecord::RecordNotFound do |e|
    #   json_response({ message: e.message }, :not_found)
    #   end
    #
    # rescue_from ActiveRecord::RecordInvalid do |e|
    #   json_response({ message: e.message }, :unprocessable_entity)
    # end
  end
end
