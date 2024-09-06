class CreateSpreeProductVideoTaggings < SpreeExtension::Migration[4.2]
  def change
    create_table :spree_product_video_taggings do |t|
      t.integer :product_video_id
      t.integer :product_video_tag_id

      t.timestamps null: false
    end

    add_index :spree_product_video_taggings, [:product_video_id, :product_video_tag_id], unique: true, name: 'index_spree_pv_taggings_on_pv_id_and_pt_id'
  end
end
