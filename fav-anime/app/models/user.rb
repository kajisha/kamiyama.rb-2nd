class User
  include Neo4j::ActiveNode

  property :nickname, type: String

  has_many :out, :favorite_animes, type: :favorite, model_class: 'Anime'
end
