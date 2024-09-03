class CreateSpreeVideoTags < SpreeExtension::Migration[4.2]
  def change
    create_table :spree_video_tags do |t|
      t.integer :video_id
      t.integer :tag_id

      t.timestamps null: false
    end

    add_index :spree_video_tags, [:video_id, :tag_id], unique: true
  end
end
