class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string     :title
      t.text       :abstract
      t.references :speaker

      t.timestamps
    end
    add_index :sessions, :speaker_id
  end
end
