class InitTables < ActiveRecord::Migration
  def change
    create_table :prefs do |t|
      t.string :keys
      t.hstore :values
    end
  end
end
