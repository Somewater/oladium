class I18nCategoriesTitle < ActiveRecord::Migration

  include I18nColumns::Migrate

  def up
    up_i18n_column :categories, :title, :string, true
  end

  def down
    down_i18n_column :categories, :title, true
  end
end
