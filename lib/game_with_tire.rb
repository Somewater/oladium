# encoding: utf-8

module GameWithTire
  extend ActiveSupport::Concern

  included do
    include Tire::Model::Search
    include Tire::Model::Callbacks

    tire.mapping do
      indexes :id,            index: :not_analyzed, include_in_all: false
      indexes :image,         index: :not_analyzed, include_in_all: false
      indexes :title,         analyzer: 'snowball', boost: 100
      indexes :description,   analyzer: 'snowball'
      indexes :slug,          include_in_all: false
      indexes :tags,          analyzer: 'keyword',  include_in_all: false
      indexes :priority,      index: :not_analyzed, include_in_all: false, type: 'integer', include_in_all: false
      indexes :votes,         index: :not_analyzed, include_in_all: false, type: 'integer', include_in_all: false
      indexes :votings,       index: :not_analyzed, include_in_all: false, type: 'integer', include_in_all: false
      indexes :usage,         index: :not_analyzed, include_in_all: false, type: 'integer', include_in_all: false
      indexes :enabled,       index: :not_analyzed, include_in_all: false, type: 'boolean', include_in_all: false
    end
  end

  def to_indexed_hash
    { id: id.to_s,
      image: image,
      title: title,
      description: description,
      slug: slug,
      tags: tags.to_s.split(',').map(&:strip),
      priority: priority,
      votes: votes,
      votings: votings,
      usage: usage,
      enabled: enabled
    }
  end

  def to_indexed_json
    JSON.fast_unparse to_indexed_hash
  end
end