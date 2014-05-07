class RegistrationsController < ApplicationController
  
  before_action :set_registration, only: [:edit, :update, :destroy]
  
  authorize_resource

  # def index
  # end

  # def show
  # end

  def new
    @registration = Registration.new
  end

  def edit
  end

  def create
    @registration = Registration.new(registration_params)
    puts registration_params
    if @registration.save
      redirect_to camp_path(@registration.camp), notice: "#{@registration.student.proper_name} has been registered for #{@registration.camp.name}."
    else
      # render action: 'new'
    end
  end

  def update
    if @registration.update(registration_params)
      flash[:notice] = "#{@registration.student.proper_name} has been updated for #{@registration.camp.name}."
    else
      # render action: 'edit'
    end
  end

  def destroy
    @registration.destroy
    flash[:notice] = "#{@registration.student.proper_name} has been removed from #{@registration.camp.name}."
  end

  private
    def set_registration
      @registration = Registration.find(params[:id])
    end

    def registration_params
      params.require(:registration).permit(:camp_id, :student_id, :payment_status, :points_earned)
    end
  
end
