class CreateBugs < ActiveRecord::Migration[5.2]
  def change
    create_table :bugs do |t|
      t.text :description
      t.references :project, foreign_key: true
    end
  end
end
