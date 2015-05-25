class ReviewsController < ApplicationController

  before_action :require_user
  
  def create
    @video = Video.find_by(params[:id])
    @review = @video.reviews.build(params.require(:review).permit(:rating, :body))
    @review.user = current_user
    if @review.save
      flash[:notice] = 'Your comment was added'
      redirect_to @video
    else
      flash[:error] = 'Your comment was not added'
      render 'videos/show'
    end
  end

end