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

      def create
        result = ::Events::Create.call(event_params)

        if result.success?
          render json: result.data.event, status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_content
        end
      end

      def update
        result = ::Events::Update.call(event_params.merge(id: params[:id]))

        if result.success?
          render json: result.data.event
        else
          render json: { errors: result.errors }, status: update_failure_status(result)
        end
      end

      def destroy
        result = ::Events::Destroy.call(params.permit(:id))

        if result.success?
          head :no_content
        else
          render json: { errors: result.errors }, status: destroy_failure_status(result)
        end
      end

      private

      def filter_params
        params.permit(:status, :starts_at, :ends_at)
      end

      def event_params
        params.expect(event: [ :name, :description, :starts_at, :ends_at, :capacity, :status, :user_id ])
      end

      def update_failure_status(result)
        return :not_found if result.errors.key?(:id)

        :unprocessable_content
      end

      def destroy_failure_status(result)
        return :not_found if result.errors.key?(:id)

        :conflict
      end
    end
  end
end
