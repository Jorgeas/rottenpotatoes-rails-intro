class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # read sort from params, then session
    sort = !params[:sort].nil? ? params[:sort] : session[:sort]
    # read checked from params, then session, then database
    if !params[:ratings].nil? 
      @checked = params[:ratings].keys
    elsif !session[:checked].nil?
      @checked = session[:checked]
    else
      @checked = Movie.getRatings
    end
    
    # get movies
    if !sort.nil?
      @movies = Movie.where("rating IN (?)", @checked).order(sort)
    else
      @movies = Movie.where("rating IN (?)", @checked)
    end
    
    # sorting style
    if !sort.nil?
      if sort == 'title'
        @title_header_class = 'hilite'
      else
        @release_date_header_class = 'hilite'
      end
    end
    
=begin
    if sort == 'title'
      @movies = Movie.order(:title)
      @title_header_class = 'hilite'
      @checked = session[:checked]
      session[:sort] = 'title'
    elsif sort == 'release_date'
      @movies = Movie.order(:release_date)
      @release_date_header_class = 'hilite'
      @checked = session[:checked]
      session[:sort] = 'release_date'
    elsif params[:ratings] != nil
      @movies = Movie.where("rating IN (?)", params[:ratings].keys)
      @checked = params[:ratings].keys
      session[:checked] = @checked
    else
      @movies = Movie.all
      session.clear
    end
=end
    # setting session
    session[:sort] = sort
    session[:checked] = @checked
    # all rating values
    @all_ratings = Movie.getRatings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
