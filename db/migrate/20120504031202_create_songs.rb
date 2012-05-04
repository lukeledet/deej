class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :artist
      t.string :album
      t.string :title
      t.string :genre
      t.string :path
      t.integer :length
      t.integer :play_count, default: 0

      t.timestamps
    end
  end
end
