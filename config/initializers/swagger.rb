GrapeSwaggerRails.options.api_auth = 'basic'
GrapeSwaggerRails.options.api_key_name = 'Authorization'
GrapeSwaggerRails.options.api_key_type = 'header'
GrapeSwaggerRails.options.before_action_proc = proc {
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
}

GrapeSwaggerRails.options.app_name = 'Bikeramp'
GrapeSwaggerRails.options.doc_expansion = 'list'
GrapeSwaggerRails.options.hide_api_key_input = true
GrapeSwaggerRails.options.hide_url_input = true
GrapeSwaggerRails.options.url = '/api/docs'
