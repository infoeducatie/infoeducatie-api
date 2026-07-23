class CreateApiCredentials < ActiveRecord::Migration[8.1]
  def change
    create_table :api_credentials do |t|
      t.string :name, null: false
      t.text :description
      t.string :token_identifier, null: false
      t.string :secret_digest, null: false
      t.jsonb :scopes, null: false, default: []
      t.datetime :expires_at, null: false
      t.datetime :revoked_at
      t.references :created_by,
        type: :integer,
        foreign_key: {to_table: :users, on_delete: :nullify}
      t.references :revoked_by,
        type: :integer,
        foreign_key: {to_table: :users, on_delete: :nullify}
      t.datetime :last_used_at
      t.string :last_used_ip, limit: 45
      t.bigint :use_count, null: false, default: 0

      t.timestamps
    end

    add_index :api_credentials, :token_identifier, unique: true
    add_index :api_credentials, [:revoked_at, :expires_at]
  end
end
