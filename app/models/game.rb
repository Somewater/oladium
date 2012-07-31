class Game < ActiveRecord::Base
  attr_accessible :net, :body, :description, :driving, :height, :slug, :net_id, :priority, :title,
                  :type, :width, :image, :tags
end
