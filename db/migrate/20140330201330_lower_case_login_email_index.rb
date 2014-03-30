class LowerCaseLoginEmailIndex < ActiveRecord::Migration
  def up
    remove_index! "developers", "index_developers_on_email"
    remove_index! "developers", "index_developers_on_login"

    execute <<-SQL
      CREATE UNIQUE INDEX index_developers_on_email_lower ON developers(lower(email));
      CREATE UNIQUE INDEX index_developers_on_login_lower ON developers(lower(login));
    SQL
  end

  def down
    remove_index! "developers", "index_developers_on_email_lower"
    remove_index! "developers", "index_developers_on_login_lower"

    add_index "developers", ["email"], :name => "index_developers_on_email", :unique => true
    add_index "developers", ["login"], :name => "index_developers_on_login", :unique => true
  end
end
