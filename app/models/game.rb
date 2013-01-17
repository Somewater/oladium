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

  def opts
    unless @opts_cache
      p = self.options.to_s
      @opts_cache = {}
      p.split(';').each do |pair|
        k, v = pair.split('=')
        @opts_cache[k.to_sym] =
            if v == 'true'
              true
            elsif v == 'false'
              false
            elsif v.match(/^\d+$/)
              v.to_i
            elsif v.match(/^\d+\.\d+$/)
              v.to_f
            else
              v
            end
      end
    end
    @opts_cache
  end

  def opts=(value)
    s = value ? value.map{|k,v| '' << k.to_s << '=' << v.to_s }.join(';') : nil
    self.options = s && s.size == 0 ? nil : s
  end

  def options=(value)
    @opts_cache = nil
    super(value)
  end
end
