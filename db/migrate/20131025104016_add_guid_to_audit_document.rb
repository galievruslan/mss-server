class AddGuidToAuditDocument < ActiveRecord::Migration
  def change
    add_column :audit_documents, :guid, :string
    add_index :audit_documents, :guid
  end
end
