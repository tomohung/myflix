CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      production: '',
      aws_access_key_id: '',
      aws_secret_access_key: ''
    }
    config.fog_directory = 'name_of_directory'
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end