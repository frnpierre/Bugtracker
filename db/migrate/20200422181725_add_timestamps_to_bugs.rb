class AddTimestampsToBugs < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :bugs, null: false
  end
end
