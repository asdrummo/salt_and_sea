class ProductImgUrl < ActiveRecord::Migration
  def up
    add_column :products, :image_url, :string
  end

  def down
  end
end
