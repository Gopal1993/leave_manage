class CreateLeaves < ActiveRecord::Migration[5.2]
  def change
    create_table :leaves do |t|
      t.string :leave_to
      t.string :leave_from
      t.integer :leave_type
      t.integer :status
      t.string :comment

      t.timestamps
    end
  end
end
