class RemoveConferenceDates < ActiveRecord::Migration
  def change
    remove_column :conferences, :dates
  end
end
