class ExpertsController < ApplicationController
  before_action :set_expert, only: [:show, :destroy, :add_friend, :find_friend]
  respond_to? :html, :json
  protect_from_forgery with: :null_session, only: [:add_friend, :find_friend]

  def index
    @experts = Expert.all
  end

  def show
  end

  def new
    @expert = Expert.new
  end

  def create
    @expert = Expert.new(expert_params)

    respond_to do |format|
      if @expert.save
        format.html { redirect_to @expert, notice: 'Expert was successfully created.' }
        format.json { render :show, status: :created, location: @expert }
      else
        format.html { render :new }
        format.json { render json: @expert.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @expert.destroy
  end

  def add_friend
    friend_name = params['friend']
    friend = Expert.find_by_name(friend_name)
    @expert.add_friend(friend)
    head :ok
  end

  def find_friend
    subject = params['subject']
    if subject.blank?
      respond_to do |format|
        head :unprocessable_entity
      end
      return
    end
    friend_path = @expert.find_friend(subject)
    respond_to do |format|
      format.json { render json: friend_path, status: :ok}
    end
  end

 private
  def set_expert
    @expert = Expert.find(params[:id])
  end

  def expert_params
    params.require(:expert).permit(:name, :website)
  end

end
