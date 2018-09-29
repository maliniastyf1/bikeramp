# frozen_string_literal: true

Rails.application.routes.draw do
  mount Bikeramp::Trip, at: '/'
  mount GrapeSwaggerRails::Engine => '/swagger'
end
