class MoviesController < ApplicationController

  attr_accessor :sort, :all_ratings, :selected_ratings

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def restore_session
    missing_params = 0

    if !params[:sort].nil?
      if params[:sort] == 'title'
        session[:sort]='title'
      elsif params[:sort] == 'date'
        session[:sort]='date'
      end
    end

    if !params[:ratings].nil?
      session[:ratings] = params[:ratings]
    end

    if params[:sort].nil? && !session[:sort].nil?
      missing_params = 1
    end
    if params[:ratings].nil? && !session[:ratings].nil?
      missing_params = 1
    end

    if !session[:ratings].nil?
      @selected_ratings = session[:ratings]
      if session[:sort] == 'title'
        @sort = 'title'
        @movies = Movie.where(rating: session[:ratings].keys).order("title ASC")
      elsif session[:sort] == 'date'
        @sort = 'date'
        @movies = Movie.where(rating: session[:ratings].keys).order("release_date ASC")
      else
        @movies = Movie.where(rating: session[:ratings].keys)
      end
    elsif session[:sort] == 'title'
      @sort = 'title'
      @movies = Movie.all(:order => "title ASC")
    elsif session[:sort] == 'date'
      @sort = 'date'
      @movies = Movie.all(:order => "release_date ASC")
    else
      @movies = Movie.all
    end

    if missing_params == 1
      flash.keep
      redirect_to action: 'index', sort: @sort, ratings: @selected_ratings
    end

  end


  def index
    @selected_ratings = Movie.getAllRatings
    @all_ratings = Movie.getAllRatings
    restore_session
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
