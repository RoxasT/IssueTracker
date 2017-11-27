class CommentsController < ApplicationController
  acts_as_token_authentication_handler_for User
	def create
    @comment = Comment.new(comment_params)
    @issue = Issue.find(params[:issue_id])
    @comment.issue_id = @issue.id
    @comment.user_id = current_user.id
    @comment.save
    redirect_to issue_path(@issue)
  end
  
  def destroy
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.find(params[:id])
    @comment.destroy
    redirect_to issue_path(@issue)
  end
 
  private
    def comment_params
      params.require(:comment).permit(:body, :attachment)
    end
end
