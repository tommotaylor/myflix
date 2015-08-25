CarrierWave.configure do |config|
  if Rails.env.staging? or Rails.env.production?
    config.storage    = :aws
    # config.aws_bucket = ENV.fetch('S3_BUCKET_NAME')
    config.aws_acl    = 'public-read'

    config.aws_credentials = {
      :aws_bucket => ENV['S3_BUCKET_NAME']
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
      :region => ENV['AWS_REGION']
    }
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end 
end