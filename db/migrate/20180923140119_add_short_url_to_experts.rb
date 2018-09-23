class AddShortUrlToExperts < ActiveRecord::Migration[5.1]
  def change
    add_column :experts, :short_url, :string
  end
end
