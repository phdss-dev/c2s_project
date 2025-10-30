class CreateEmlFiles < ActiveRecord::Migration[8.1]
  def change
    create_table :eml_files do |t|
      t.integer :status
      t.datetime :processed_at

      t.timestamps
    end
  end
end
