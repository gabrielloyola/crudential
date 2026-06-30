module Api
  module V1
    class EventsController < ApplicationController
      def index
        result = ::Events::List.call(filter_params)

        if result.success?
          render json: result.data.events
        else
          render json: { errors: result.errors }, status: :unprocessable_content
        end
      end

      def show
        result = ::Events::Show.call(params.permit(:id))

        if result.success?
          render json: result.data.event
        else
          render json: { errors: result.errors }, status: :not_found
        end
      end

      private

      def filter_params
        params.permit(:status, :starts_at, :ends_at)
      end
    end
  end
end
