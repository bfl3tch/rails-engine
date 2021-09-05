module ExceptionHandler
  extend ActiveSupport::Concern
  included do

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json:
        {
          errors:
          [
            {
              status: e.status,
              message: e.message,
              code: e.code
            }
          ]
        }
    end
  end
end
