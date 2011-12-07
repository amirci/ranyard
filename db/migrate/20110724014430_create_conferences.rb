class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string  :name
      t.date    :start
      t.date    :finish
      t.boolean :active
      
      t.timestamps
    end
  end
end
