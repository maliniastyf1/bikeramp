# frozen_string_literal: true

module Bikeramp
  class Base < Grape::API
    prefix :api
    content_type :json, 'application/vnd.api+json'
    default_format :json

    helpers Bikeramp::Helpers::ParamsHelpers

    mount Bikeramp::Trips::Create
    mount Bikeramp::Stats::Monthly
    mount Bikeramp::Stats::Weekly

    add_swagger_documentation \
      mount_path: '/docs',
      produces: 'application/vnd.api+json',
      array_use_braces: true,
      security_definitions: {
        api_key: { type: 'basic', name: 'Authorization', in: 'header' }
      }
  end
end
