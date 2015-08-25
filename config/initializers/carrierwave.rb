CarrierWave.configure do |config|
  if Rails.env.staging? or Rails.env.production?
    config.storage    = :aws
    config.aws_bucket = ENV.get('S3_BUCKET_NAME')
    config.aws_acl    = 'public-read'

    config.aws_credentials = {
      access_key_id:     ENV.get('AWS_ACCESS_KEY_ID'),
      secret_access_key: ENV.get('AWS_SECRET_ACCESS_KEY'),
      region:            ENV.get('AWS_REGION')
    }
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end 
end