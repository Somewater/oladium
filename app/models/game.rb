class Game < ActiveRecord::Base

  TYPE_EMBED = 'embed'
  TYPE_FILE = 'file'

  attr_accessible :net, :body, :description, :driving, :height, :slug, :net_id, :priority, :title,
                  :type, :width, :image, :tags
end
