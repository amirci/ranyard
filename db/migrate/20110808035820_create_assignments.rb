class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.references :speaker
      t.references :session
      t.timestamps
    end
    
    remove_column(:sessions, :speaker_id)
  end
end
