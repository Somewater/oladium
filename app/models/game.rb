class Game < ActiveRecord::Base

  TYPE_EMBED = 'embed'
  TYPE_FILE = 'file'

  self.inheritance_column = :nothing

  attr_accessible :net, :body, :description, :driving, :height, :slug, :net_id, :priority, :title,
                  :type, :width, :image, :tags

  belongs_to :category

  def category
    super || Category.default
  end

  def to_param
    n = self.slug
    n = super unless n && n.size > 0
    n
  end
end
