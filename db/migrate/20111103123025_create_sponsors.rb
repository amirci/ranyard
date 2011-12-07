class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.string :name
      t.text :description
      t.string :logo_file_name
      t.string :category

      t.timestamps
    end
  end
end
