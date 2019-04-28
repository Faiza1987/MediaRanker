class VotesController < ApplicationController
  def upvote
    # @vote = Vote.new(
    #   user_id: @user = User.find_by(id: session[:user_id]),
    #   work_id: @work = Work.find_by(id: params[:work_id])
    #   )

    @vote = Vote.new(user_id: session[:user_id], work_id: params[:work_id])

    if @vote.save
      flash[:status] = :success
      flash[:success] = "Successfully upvoted!"

      # redirect_to work_path(params[:work_id])
      redirect_back(fallback_location: works_path)
      # return
    
    else
      flash[:status] = :failure
      if @vote.errors.messages.include?(:user_id)
        flash[:alert] = "You must log in to do that"
      else @vote.errors.messages.include?(:user)
        flash[:alert] = "Could not upvote"
        flash[:details] = @vote.errors.messages
      end
      redirect_to works_path
    end
  end
end
