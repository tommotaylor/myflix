CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage    = :aws
    config.aws_bucket = ENV.pull('S3_BUCKET_NAME')
    config.aws_acl    = :'public-read'

    config.aws_credentials = {
      access_key_id:     ENV.pull('AWS_ACCESS_KEY_ID'),
      secret_access_key: ENV.pull('AWS_SECRET_ACCESS_KEY'),
      region:            ENV.pull('AWS_REGION')
    }
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end