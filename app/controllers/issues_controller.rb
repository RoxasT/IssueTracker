class IssuesController < ApplicationController
  protect_from_forgery with: :null_session
  acts_as_token_authentication_handler_for User, fallback: :devise
  before_action :set_issue, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /issues
  # GET /issues.json
  
  def index
    respond_to do |format|
      @issues = Issue.all
      
      if params.has_key?(:assignee)
        if User.exists?(id: params[:assignee])
          @issues = @issues.where(assignee_id: params[:assignee])
        else
          format.json {render json: {"error":"User with id="+params[:assignee]+" does not exist"}, status: :unprocessable_entity}
        end
      end
      
      if params.has_key?(:type)
        @issues = @issues.where(Type: params[:type])
      end
      
      if params.has_key?(:priority)
        @issues = @issues.where(Priority: params[:priority])
      end
      
      if params.has_key?(:status)
        if params[:status] == "New&Open"
          @issues = @issues.where(Status: ["Open","New"])
        else
        @issues = @issues.where(Status: params[:status])
        end
      end
      
      if params.has_key?(:watcher)
        if User.exists?(id: params[:watcher])
          @issues = Issue.joins(:watchers).where(watchers:{user_id: params[:watcher]})
        else
          format.json {render json: {"error":"User with id="+params[:watcher]+" does not exist"}, status: :unprocessable_entity}
        end
      end

      format.html
      format.json {render json: @issues, status: :ok, each_serializer: IssueIndexSerializer}
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    respond_to do |format|
      format.html
      format.json {render json: @issue, status: :ok, serializer: IssueSerializer}
    end
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(issue_params)
    @issue.user_id = current_user.id
    respond_to do |format|
      if (issue_params.has_key?(:assignee_id) && issue_params[:assignee_id] != "" && !User.exists?(id: issue_params[:assignee_id]))
          format.json {render json: {"error":"User with id="+issue_params[:assignee_id]+" does not exist"}, status: :unprocessable_entity}
      else
        if @issue.save
          @watcher = Watcher.new
          @watcher.user_id = current_user.id
          @watcher.issue_id = @issue.id
          @watcher.save
          @issue.increment!("Watchers")
          format.html { redirect_to @issue }
          format.json { render json: @issue, status: :created, serializer: IssueSerializer }
        else
          format.html { render :new }
          format.json { render json: @issue.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    respond_to do |format|
      if !User.exists?(id: params[:assignee_id])
          format.json {render json: {"error":"User with id="+params[:assignee_id]+" does not exist"}, status: :unprocessable_entity}
      else
        @issue_to_update = Issue.find(params[:id])
        @issue_to_update.update(issue_params)
        
        format.html { redirect_to @issue_to_update }
        format.json { render json: @issue_to_update, status: :ok, serializer: IssueSerializer}
      end
    end
  end
  
  def update_status
    respond_to do |format|
      @issue_to_update = Issue.find(params[:id])
      @issue_to_update.update_attribute("Status", params[:status])
      
      format.html { redirect_to @issue_to_update }
      format.json { render json: @issue_to_update, status: :ok }
    end
  end
  
  
  # POST /issues/{issue_id}/watch
  
  def watch
    respond_to do |format|
      @issue_to_watch = Issue.find(params[:id])
      if !Watcher.exists?(:issue_id => @issue_to_watch.id, :user_id => current_user.id)
        @watcher = Watcher.new
        @watcher.user_id = current_user.id
        @watcher.issue_id = @issue_to_watch.id
        @watcher.save
        @issue_to_watch.increment!("Watchers")
      else
        @watcher = Watcher.where(issue_id: params[:id], user_id: current_user.id).take
        @watcher.destroy
        @issue_to_watch.decrement!("Watchers")
      end
      if params[:view] == "index"
        format.html { redirect_to issues_url}
      else
        format.html { redirect_to @issue_to_watch}
      end
      format.json { render json: @issue_to_watch, status: :ok }
    end
  end
  
  
  # POST /issues/{issue_id}/vote
  
  def vote
    respond_to do |format|
      @issue_to_vote = Issue.find(params[:id])
      if !Vote.exists?(:issue_id => @issue_to_vote.id, :user_id => current_user.id)
        @vote = Vote.new
        @vote.user_id = current_user.id
        @vote.issue_id = @issue_to_vote.id
        @vote.save
        @issue_to_vote.increment!("Votes")
      else
        @vote = Vote.where(issue_id: params[:id], user_id: current_user.id).take
        @vote.destroy
        @issue_to_vote.decrement!("Votes")
      end
      format.html { redirect_to @issue_to_vote }
      format.json { render json: @issue_to_vote, status: :ok }
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to issues_url }
      format.json { render json: {"message": "success"}, status: :ok }
    end
  end

  def show_attachment
    @issue = Issue.find(params[:id])
    respond_to do |format|
      if @issue.attachment.file?
        format.json {render json: @issue, status: :ok, serializer: IssueattachmentSerializer}
      else
        format.json {render json: {}, status: :ok}
      end
    end
  end

  def create_attachment
    @issue = Issue.find(params[:id])
    if @issue.user.id == current_user.id
      @issue.attachment = Paperclip.io_adapters.for(params[:file])
      @issue.attachment.instance_write(:file_name, SecureRandom.hex(10))
      @issue.save
    end
    respond_to do |format|
      if @issue.user.id == current_user.id
        format.json {render json: @issue, status: :created, serializer: IssueattachmentSerializer}
      else
        format.json {render json: {error: "Forbidden, you are not the creator of this issue"}, status: :forbidden}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
      render json: { error: 'Issue not found' }, status: :not_found if @issue.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params.permit(:Title, :Description, :Type, :Priority, :Status, :assignee_id, :user_id, :attachment)
    end
end
