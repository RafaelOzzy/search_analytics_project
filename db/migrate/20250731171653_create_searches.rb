class CreateSearches < ActiveRecord::Migration[7.1]
  def change
    create_table :searches do |t|
      t.string :term
      t.string :ip_address

      t.timestamps
    end
  end
end
