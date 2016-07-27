CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = ''
  config.aws_acl    = 'public-read'

  config.aws_attributes = {
    expires: 1.week.from_now.httpdate,
    cache_control: ''
  }

  config.aws_credentials = {
    access_key_id:     '',
    secret_access_key: '',
    region:            '') # Required
  }

end