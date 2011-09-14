class ResearchItem < ActiveRecord::Migration
  def up
 create_table :research_items do |t|
      t.string     :title, :limit => 255, :null => true
      t.text       :body
      t.string     :url, :limit => 255, :null => true
      t.column     :research_item_id,  :integer      
      t.timestamp  :created_at
      t.string     :rssurl, :limit => 255, :null => true
      t.integer    :created_by
      t.integer    :project_id
      t.column     :dialogue_association, 'bigint'      
    end

  end

  def down
  end
end
