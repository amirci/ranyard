class AddFieldsToSpeaker < ActiveRecord::Migration
  def change
    add_column :speakers, :website, :string
    add_column :speakers, :twitter, :string
    add_column :speakers, :location, :string
    add_column :speakers, :blog, :string
    add_column :speakers, :picture, :string
  end
end
