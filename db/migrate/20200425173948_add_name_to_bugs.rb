class AddNameToBugs < ActiveRecord::Migration[5.2]
  def change
    add_column :bugs, :name, :string
  end
end
