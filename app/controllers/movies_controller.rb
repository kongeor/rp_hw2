class MoviesController < ApplicationController


  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    print params
    @all_ratings = %w[G PG PG-13 R]
    if params[:ratings]
      movies = Movie.where(["rating in (?)", params[:ratings].keys])
    else
      movies = Movie.all
      ones = @all_ratings.zip(%w[1 1 1 1]).flatten
      default_ratings = { :ratings => Hash[*ones] }
      redirect_to movies_path default_ratings
    end
    if params['sort_by'] == "title"
      @movies = movies.order('title')
    elsif params['sort_by'] == "release_date"
      @movies = movies.order('release_date')
    else
      @movies = movies
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

end
