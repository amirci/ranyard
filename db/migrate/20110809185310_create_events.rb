class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.datetime :start
      t.datetime :finish
      t.text     :custom
      t.boolean  :main
      t.integer  :room_id

      t.timestamps
    end
    
    add_column(:sessions, :event_id, :integer)
  end
  
  def down
    remove_column(:sessions, :event_id)
    
    drop_table :events
  end
end
