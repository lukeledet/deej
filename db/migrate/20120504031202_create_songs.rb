class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :artist
      t.string :album
      t.string :title
      t.string :path
      t.integer :length
      t.integer :play_count

      t.timestamps
    end
  end
end
