class TextPage < ActiveRecord::Base

  extend ::I18nColumns::Model
  i18n_columns :title, :body, :ferret => true
  attr_accessible :name

  def title
    t = super
    t = self.name if t.blank?
    t
  end

  def to_param
    self.name.to_s.size > 0 ? self.name : self.id
  end
end