class CreateAuditDocuments < ActiveRecord::Migration
  def change
    create_table :audit_documents do |t|
      t.datetime :date
      t.integer :manager_id
      t.integer :shipping_address_id
      t.integer :percentage_shelves
      t.text :comment

      t.timestamps
    end
  end
end
