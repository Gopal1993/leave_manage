class AddUserToLeaves < ActiveRecord::Migration[5.2]
  def change
    add_reference :leaves, :user, foreign_key: true
  end
end
