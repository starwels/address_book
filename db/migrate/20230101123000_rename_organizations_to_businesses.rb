class RenameOrganizationsToBusinesses < ActiveRecord::Migration[6.0]
  def change
    rename_table :organizations, :businesses
  end
end