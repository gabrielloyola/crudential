module Api
  module V1
    class EventsController < ApplicationController
      def index
        result = ::Events::List.call(filter_params)

        if result.success?
          render json: result.events
        else
          render json: { errors: result.errors }, status: :unprocessable_content
        end
      end

      private

      def filter_params
        params.permit(:status, :starts_at, :ends_at)
      end
    end
  end
end
