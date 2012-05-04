class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :song
      t.string :ip
      t.string :status, default: 'active'

      t.datetime :created_at
    end

    add_index :votes, :song_id
  end
end
