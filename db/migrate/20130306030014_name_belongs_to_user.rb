class NameBelongsToUser < ActiveRecord::Migration
  change_table :names do |t|
    t.references :user
  end
end
