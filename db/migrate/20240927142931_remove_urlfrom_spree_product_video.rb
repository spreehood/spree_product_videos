class RemoveUrlfromSpreeProductVideo < ActiveRecord::Migration[7.2]
  def change
    remove_column :spree_product_videos, :url
  end
end
