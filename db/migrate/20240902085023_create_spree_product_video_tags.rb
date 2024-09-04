class CreateSpreeProductVideoTags < SpreeExtension::Migration[4.2]
  def change
    create_table :spree_product_video_tags do |t|
      t.string :name, null: false
      t.references :product, foreign_key: { to_table: :spree_products }, index: true

      t.timestamps null: false
    end

    add_index :spree_product_video_tags, [:product_id, :name], unique: true
  end
end
