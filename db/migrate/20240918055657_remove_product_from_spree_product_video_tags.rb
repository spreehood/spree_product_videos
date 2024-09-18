class RemoveProductFromSpreeProductVideoTags < ActiveRecord::Migration[7.1]
  def change
    remove_reference :spree_product_video_tags, :product, foreign_key: { to_table: :spree_products }, index: true
  end
end
