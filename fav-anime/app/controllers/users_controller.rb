class UsersController < ApplicationController
  before_action :set_user, only: %i(show favorite dislike)

  def show(id)
    @favorites = @user.favorite_animes
    @recommends = recommends_for(@user)
  end

  def new
    @user = User.new
  end

  def create(user)
    @user = User.new(user)

    redirect_to @user, notice: 'User was successfully created.'
  end

  def favorite(anime_id)
    anime = Anime.find(anime_id)
    @user.favorite_animes << anime

    redirect_to @user, notice: "#{anime.title} added to favorite"
  end

  def dislike(anime_id)
    anime = Anime.find(anime_id)
    @user.favorite_animes(:anime, :rel).match_to(anime).delete_all(:rel)

    redirect_to @user, notice: "#{anime.title} deleted to favorite"
  end

  private

  def set_user(id); @user = User.find(id) end

  def recommends_for(user)
    recommends = Neo4j::Session.open.query <<-EOQ.strip_heredoc
      MATCH (u:User)-[:favorite]->(a:Anime)<-[:favorite]-(other:User),
            (other)-[:favorite]->(anime:Anime)
      WHERE u.uuid = '#{user.id}'
      AND NOT (u)-[:favorite]->(anime)
      RETURN count(a) as weight, anime
      ORDER BY weight DESC LIMIT 20
    EOQ

    recommends.to_a.map(&:anime)
  end
end
