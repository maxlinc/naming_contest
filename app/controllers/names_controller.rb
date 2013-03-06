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

    score
  end

  def score
    names = Name.all
    response = names.inject({}) do |result, name|
      result[name.id] = {up: name.votes_for, down: name.votes_against}
      result
    end
    render :json => response
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
