class AddSolvedToBugs < ActiveRecord::Migration[5.2]
  def change
    add_column :bugs, :solved, :boolean, default: false
  end
end
