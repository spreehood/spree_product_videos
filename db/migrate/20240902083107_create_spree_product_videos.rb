class CreateSpreeProductVideos < SpreeExtension::Migration[4.2]
  def change
    create_table :spree_product_videos do |t|
      t.string :url
      t.references :product, foreign_key: { to_table: :spree_products }, index: true
      
      t.timestamps null: false
    end
  end
end
