class CreatePageInfos < ActiveRecord::Migration
  def change
    create_table :page_infos do |t|
      t.string :url
      t.text :content
      t.timestamps null: false
    end
  end
end
