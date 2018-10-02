# frozen_string_literal: true

module Bikeramp
  module Helpers
    module ParamsHelpers
      extend ::Grape::API::Helpers

      def attributes(params)
        data = params[:data][:attributes]
        ActiveSupport::HashWithIndifferentAccess.new(data)
      end
    end
  end
end
