class Game < ActiveRecord::Base

  TYPE_EMBED = 'embed'
  TYPE_FILE = 'file'

  self.inheritance_column = :nothing

  attr_accessible :net, :body, :description, :driving, :height, :slug, :net_id, :priority, :title,
                  :type, :width, :image, :tags, :votes, :votings

  belongs_to :category

  def category
    super || Category.default
  end

  def to_param
    n = self.slug
    n = super unless n && n.size > 0
    n
  end

  def each_tag(limit = 1000, &block)
    index = 0
    self.tags.to_s.split(',').each do |tag|
      html_name = tag.gsub('+', '++').gsub(/\s+/, '+')
      block.call(tag, html_name)
      index += 1
      return if index >= limit
    end
  end

  def stars
    if(self.votings > 0)
      self.votes / self.votings.to_f
    else
      5
    end
  end
end
