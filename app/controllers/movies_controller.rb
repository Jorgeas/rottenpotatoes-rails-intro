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
    # all rating values
    @all_ratings = Movie.getRatings

    # read sort from params, then session
    if !params[:sort].nil?
      sort = params[:sort]
      # if came in params set in session
      session[:sort] = sort
    else
      sort = session[:sort]
    end

    # read checked from params, then session, then database
    if !params[:ratings].nil? 
      @checked = params[:ratings]
      # setting in session
      session[:checked] = @checked
    else
      if !session[:checked].nil?
        @checked = session[:checked]
      else
        @checked = {}
        Movie.getRatings.each do |rating|
          @checked[rating] = 1
        end
      end
      # redirect
      flash.keep
      redirect_to movies_path(:ratings => @checked, :sort => sort)
    end
    
    # get movies and sorting style
    if !sort.nil?
      @movies = Movie.where("rating IN (?)", @checked.keys).order(sort)
      # sorting style
      if sort == 'title'
        @title_header_class = 'hilite'
      else
        @release_date_header_class = 'hilite'
      end
    else
      @movies = Movie.where("rating IN (?)", @checked.keys)
    end
    
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
