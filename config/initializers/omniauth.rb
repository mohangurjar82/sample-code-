Rails.application.config.middleware.use OmniAuth::Builder do
  unless Rails.env.development?
    provider :facebook, '368210429969554', '5ae206097ac7be424b41b640396b8328'
  else
    #Facebook keys for development mode
    provider :facebook, '178566635600604', '20f35b1ef36f64ba81b03078b7ee7c45', {:client_options => {:ssl => {:verify => false}}}
  end
end
