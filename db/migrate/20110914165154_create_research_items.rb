class CreateResearchItems < ActiveRecord::Migration
  def change
    create_table :research_items do |t|
      t.string :name

      t.timestamps
    end
  end
end
