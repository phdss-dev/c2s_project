class CreateProcessingLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :processing_logs do |t|
      t.references :eml_file, null: false, foreign_key: true
      t.integer :status
      t.text :extracted_data
      t.text :errors
      t.datetime :processed_at

      t.timestamps
    end
  end
end
