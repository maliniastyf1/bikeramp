# frozen_string_literal: true

Rails.application.routes.draw do
  mount Bikeramp::Base, at: '/'
  mount GrapeSwaggerRails::Engine => '/swagger'
end
