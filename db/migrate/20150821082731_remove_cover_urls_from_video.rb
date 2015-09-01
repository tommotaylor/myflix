class RemoveCoverUrlsFromVideo < ActiveRecord::Migration
  def change
    remove_column :videos, :large_cover_url, :string
    remove_column :videos, :small_cover_url, :string
  end
end
