class AddFileDataToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :file_data, :string
  end
end
