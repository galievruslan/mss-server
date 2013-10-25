class CreateAuditDocumentItems < ActiveRecord::Migration
  def change
    create_table :audit_document_items do |t|
      t.integer :audit_document_id
      t.integer :product_id
      t.integer :quantity
      t.decimal :price, :precision => 7, :scale => 2
      t.integer :face
      t.integer :facing
      t.boolean :golden_shelf, :default => false

      t.timestamps
    end
  end
end
