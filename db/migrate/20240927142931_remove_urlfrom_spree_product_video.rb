class RemoveUrlfromSpreeProductVideo < ActiveRecord::Migration[7.1]
  def change
    remove_column :spree_product_videos, :url
  end
end
