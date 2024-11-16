class RenameOrganizationsToBusinesses < ActiveRecord::Migration[6.1]
  def change
    rename_table :organizations, :businesses
  end
end