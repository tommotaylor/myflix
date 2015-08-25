class LargeCoverUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  process :resize_to_fill => [665, 375]
  storage :aws
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
