class WorksController < ApplicationController
  before_action :find_individual_work, only: [:show, :edit, :update, :destroy, :upvote]

  def index
    @albums = Work.sort_by_category("album")
    @books = Work.sort_by_category("book")
    @movies = Work.sort_by_category("movie")
  end

  def show
    if @work.nil?
      flash[:error] = "Unknown work"
      redirect_to works_path
    end
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)

    save_is_successful = @work.save

    if save_is_successful
      flash[:success] = "Successfully added work of art to database"
      redirect_to work_path(@work.id)
    else
      @work.errors.messages.each do |field, messages|
        flash.now[field] = messages
      end
      render :new, status: :bad_request
    end
  end

  def edit
  end

  def update
    if @work.update(work_params)
      flash[:success] = "Details of #{@work.title} have been updated"
      redirect_to work_path(@work.id)
    else
      @work.errors.messages.each do |field, messages|
        flash.now[field] = messages
      end
      render :edit, status: :bad_request
    end
  end

  
  def destroy
    
    if @work.nil?
      flash[:error] = "#{@work.title} does not exist"
      redirect_to works_path
    else
      @work.destroy
      flash[:success] = "#{@work.title} has been deleted"
      redirect_to works_path
    end
  end
  
  private

  def work_params
    return params.require(:work).permit(:title, :creator, :description, :category, :publication_year)
  end

  def find_individual_work
    @work = Work.find_by(id: params[:id])
  end
end
