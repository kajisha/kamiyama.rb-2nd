json.array!(@animes) do |anime|
  json.extract! anime, :id, :title
  json.url anime_url(anime, format: :json)
end
