class ExpertsController < ApplicationController
  before_action :set_expert, only: [:show, :destroy]
  respond_to? :html, :json

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

 private
  def set_expert
    @expert = Expert.find(params[:id])
  end

  def expert_params
    params.require(:expert).permit(:name, :website)
  end

end
