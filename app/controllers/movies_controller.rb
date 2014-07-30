class MoviesController < ApplicationController
  helper_method :sort_column, :sort_direction

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    # get which movie field to sort by
    order_field = sort_column
    direction = sort_direction

    # filter by rating criteria
    ratings = params[:ratings] || session[:ratings]

    unless ratings.nil?
      # only get specified ratings
      session[:ratings] = ratings
      @movies = Movie.find_all_by_rating(ratings.keys, :order => order_field + " " + direction)
    else
      # get all ratings by default
      session[:ratings] = Hash.new
      @all_ratings.each do |rating|
        session[:ratings][rating] = '1'
      end
      @movies = Movie.order(order_field + " " + direction)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def sort_column
    # sanitize input
    %w[title rating release_date].include?(params[:sort]) ? params[:sort] : 'title'
  end

  def sort_direction
    # sanitize input
    %w[asc desc].include?(params[:direction]) ? params[:direction] : ''
  end

end
