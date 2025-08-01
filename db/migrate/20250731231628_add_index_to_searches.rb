class AddIndexToSearches < ActiveRecord::Migration[7.1]
  def change
    add_index :searches, [:term, :ip_address]
  end
end
