class AddBugToComments < ActiveRecord::Migration[5.2]
  def change
    add_reference :comments, :bug, foreign_key: true
  end
end
