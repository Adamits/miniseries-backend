class AddCompositionsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :compositions_count, :integer, default: 0
  end
end
