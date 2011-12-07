class AddPlanningToAttendToSession < ActiveRecord::Migration

  def up
    change_table :sessions do |t|
      t.integer :planning_to_attend
    end
  end

  def down
    change_table :sessions do |t|
      t.remove :planning_to_attend
    end
  end

end
