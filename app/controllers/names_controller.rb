class NamesController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :check_sign_in, :only => [:new, :create, :vote]
  before_action :set_name, only: [:show, :edit, :update, :destroy, :vote]

  # GET /names
  # GET /names.json
  def index
    after = params[:after] ||= 0
    @names = Name.where("created_at > ?", Time.at(after.to_i + 1))
    @votes = Vote.where("created_at > ?", Time.at(after.to_i + 1))
  end

  # GET /names/1
  # GET /names/1.json
  def show
  end

  # GET /names/new
  def new
    @name = Name.new
  end

  # GET /names/1/edit
  def edit
  end

  # POST /names
  # POST /names.json
  def create
    a_hash = {user_id: current_user.id}
    name_params.merge! a_hash
    @name = Name.new(name_params)

    respond_to do |format|
      if @name.save
        format.html { redirect_to @name, notice: 'Name was successfully created.' }
        format.json { render action: 'show', status: :created, location: @name }
      else
        format.html { render action: 'new' }
        format.json { render json: @name.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /names/1
  # PATCH/PUT /names/1.json
  def update
    respond_to do |format|
      if @name.update(name_params)
        format.html { redirect_to @name, notice: 'Name was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @name.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /names/1
  # DELETE /names/1.json
  def destroy
    @name.destroy
    respond_to do |format|
      format.html { redirect_to names_url }
      format.json { head :no_content }
    end
  end

  def votes
    @votes = Vote.where("created_at > ?", Time.at(params[:after].to_i + 1))
  end

  def vote
    against = (params[:vote] == 'false')
    if against
      current_user.vote_exclusively_against @name
    else
      current_user.vote_exclusively_for @name
    end

    render :json => {up: @name.votes_for, down: @name.votes_against}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_name
      @name = Name.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def name_params
      params.require(:name).permit(:title, :subtitle)
    end
end
