class CommentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  protect_from_forgery with: :null_session
  acts_as_token_authentication_handler_for User, fallback: :devise
  before_action :authenticate_user!

  def index
    comments = Comment.where(issue_id: params[:issue_id])
    respond_to do |format|
      format.json {render json: comments, status: :ok}
    end
  end

  def show
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.json {render json: @comment, status: :ok}
    end
  end

	def create
    @comment = Comment.new(comment_params)
    @issue = Issue.find(params[:issue_id])
    @comment.issue_id = @issue.id
    @comment.user_id = current_user.id
    @comment.save
    respond_to do |format|
      format.json {render json: @comment, status: :created}
      format.html {redirect_to issue_path(@issue)}
    end
  end
  
  def destroy
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.find(params[:id])
    if @comment.user_id == current_user.id
      @comment.destroy
    end
    respond_to do |format|
      if @comment.user_id == current_user.id
        format.json {render json: {}, status: :ok}
        format.html {redirect_to issue_path(@issue)}
      else
        format.json {render json: {error: "Forbidden, you are not the creator of this comment"}, status: :forbidden}
      end
    end
  end

  def update
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.find(params[:id])
    if @comment.user_id == current_user.id
      @comment.update(comment_params)
    end
    respond_to do |format|
      if @comment.user_id == current_user.id
        format.json {render json: @comment, status: :ok}
        format.html {redirect_to issue_path(@issue)}
      else
        format.json {render json: {error: "Forbidden, you are not the creator of this comment"}, status: :forbidden}
      end
    end
  end
 
  private
    def comment_params
      params.permit(:body, :attachment, :issue_id, :user_id, :comment)
    end

    def record_not_found(error)
      respond_to do |format|
        format.json {render json: {error: error.message }, status: :not_found}
      end
    end
end
