class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /issues
  # GET /issues.json
  
  def index
    
    @issues = Issue.all
    
    if params.has_key?(:assignee)
      if User.exists?(name: params[:assignee])
        @issues = @issues.where(assignee_id: User.find_by(name: params[:assignee]).id)
      else
        @issues = []
      end
    end
    
    @issues = Issue.where(nil) # creates an anonymous scope
    @issues = @issues.type(params[:type]) if params[:type].present?
    @issues = @issues.priority(params[:priority]) if params[:priority].present?
    
    respond_to do |format|
      format.html
      format.json {render json: @issues, status: :ok, each_serializer: IndexIssueSerializer}
    end

    #@issues = Issue.all

    #if params.has_key?(:assignee)
     # if User.exists?(name: params[:assignee])
      #  @issues = @issues.where(assignee_id: User.find_by(name: params[:assignee]).id)
      #else
      #  @issues = []
      #end
   # end
    
    #if params[:watching]
     # @user = User.find_by(nickname: params[:watching])
      #@issues = @issues.to_a
     # if @user.nil?
      #  @issues.clear
     # else
      #  @issues = @issues.select {|i| i.watchers.exists?(@user.id)}
      #end
    #end

    respond_to do |format|
      format.html
      format.json {render json: @issues, status: :ok, each_serializer: IndexIssueSerializer}
    end
  end
  
  def index_status
    
    @issues = Issue.where(nil) # creates an anonymous scope
    @issues = @issues.status(params[:status]) if params[:status].present?
    
    respond_to do |format|
      format.html
      format.json {render json: @issues, status: :ok, each_serializer: IndexIssueSerializer}
    end
  end
  
  def index_type
    
    @issues = Issue.where(nil) # creates an anonymous scope
    @issues = @issues.type(params[:type]) if params[:type].present?
    
    respond_to do |format|
      format.html
      format.json {render json: @issues, status: :ok, each_serializer: IndexIssueSerializer}
    end
    
  end
  
  def index_priority
    
    @issues = Issue.where(nil) # creates an anonymous scope
    @issues = @issues.priority(params[:priority]) if params[:priority].present?
    
    respond_to do |format|
      format.html
      format.json {render json: @issues, status: :ok, each_serializer: IndexIssueSerializer}
    end
    
  end
  #def index
   # @issues = Issue.all
  #end

  # GET /issues/1
  # GET /issues/1.json
  def show
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
      if @issue.save
        format.html { redirect_to @issue, notice: 'Issue was successfully created.' }
        format.json { render :show, status: :created, location: @issue }
      else
        format.html { render :new }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { render :show, status: :ok, location: @issue }
      else
        format.html { render :edit }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update_status
    respond_to do |format|
      @issue_to_update = Issue.find(params[:id])
      @issue_to_update.update_attribute("Status", params[:status])
      format.html { redirect_to @issue_to_update }
    end
  end
  
  def vote
    respond_to do |format|
      @issue_to_vote = Issue.find(params[:id])
      @vote = Vote.new
      @vote.user_id = current_user.id
      @vote.issue_id = @issue_to_vote.id
      @vote.save
      @issue_to_vote.increment!("Votes")
      format.html { redirect_to @issue_to_vote}
    end
  end
  
  def unvote
    respond_to do |format|
      @vote = Vote.where(issue_id: params[:id], user_id: current_user.id).take
      @vote.destroy
      @issue_to_unvote = Issue.find(params[:id])
      @issue_to_unvote.decrement!("Votes")
      format.html { redirect_to @issue_to_unvote}
    end
  end
  
  def watch
    respond_to do |format|
      @issue_to_watch = Issue.find(params[:id])
      @watcher = Watcher.new
      @watcher.user_id = current_user.id
      @watcher.issue_id = @issue_to_watch.id
      @watcher.save
      @issue_to_watch.increment!("Watchers")
      if params[:view] == "index"
        format.html { redirect_to issues_url}
      else
        format.html { redirect_to @issue_to_watch}
      end
    end
  end
  
  def unwatch
    respond_to do |format|
      @watcher = Watcher.where(issue_id: params[:id], user_id: current_user.id).take
      @watcher.destroy
      @issue_to_unwatch = Issue.find(params[:id])
      @issue_to_unwatch.decrement!("Watchers")
      if params[:view] == "index"
        format.html { redirect_to issues_url}
      else
        format.html { redirect_to @issue_to_unwatch}
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to issues_url, notice: 'Issue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params.require(:issue).permit(:Title, :Description, :Type, :Priority, :Status, :assignee_id, :user_id, :attachment)
    end
end
