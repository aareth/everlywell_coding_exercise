class AddHeadersToExperts < ActiveRecord::Migration[5.1]
  def change
    add_column :experts, :headers, :text
  end
end
