class AddDownloadsToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :downloads, :integer, default: 0
  end
end
