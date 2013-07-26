class MoviesController < ApplicationController

  attr_accessor :sort, :all_ratings, :selected_ratings

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    if params[:sort] == 'title'
      @sort='title'
      @movies = Movie.all(:order => "title ASC")
    elsif params[:sort] == 'date'
      @sort='date'
      @movies = Movie.all(:order => "release_date ASC")
    else
      @sort='none'
      @movies = Movie.all
    end

    if !params[:ratings].nil?
      @movies = Movie.where(rating: params[:ratings].keys)
      @selected_ratings = params[:ratings]
    else
      @selected_ratings = Movie.getAllRatings
    end

      @all_ratings = Movie.getAllRatings


    #debugger



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
