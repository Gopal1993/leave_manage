class LeavesController < ApplicationController
  before_action :set_leafe, only: [:show, :edit, :update]
  before_action :authenticate_user!, only: [:employees_status_check,:index]
  before_action :employees_status_check, only: [:new]

  # GET /leaves
  # GET /leaves.json
  def index
    @leaves = Leave.where(user_id:current_user.id).all
  end

  # GET /leaves/1
  # GET /leaves/1.json
  def show
  end

  # GET /leaves/new
  def new
    @leave = Leave.new
  end

  # GET /leaves/1/edit
  def edit
  end

  # POST /leaves
  # POST /leaves.json
  def create
    @leafe = Leave.new((leafe_params).merge(user_id:current_user.id))

    respond_to do |format|
      if @leafe.save

        format.html { redirect_to leaves_path}
      else
        format.html { render :new }
        format.json { render json: @leafe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leaves/1
  # PATCH/PUT /leaves/1.json
  def update
    respond_to do |format|
      if @leafe.update(leafe_params)
        format.html { redirect_to @leafe, notice: 'Leave was successfully updated.' }
        format.json { render :show, status: :ok, location: @leafe }
      else
        format.html { render :edit }
        format.json { render json: @leafe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leaves/1
  # DELETE /leaves/1.json
  def destroy
    @leafe.destroy
    respond_to do |format|
      format.html { redirect_to leaves_url, notice: 'Leave was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
 
  def error_leave
  end
  

def employees_status_check
  if user_signed_in?
   current_employee_obj = User.where(id:current_user.id)
   current_employee_status = current_employee_obj[0].status
  #current_employee_designation = current_employee_obj[0].designation
  if current_employee_status == "active" 
    render 'new'
  else
    redirect_to error_leave_leaves_path
  end
 else
  redirect_to root_path
 end    
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leafe
      @leafe = Leave.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leafe_params
      params.fetch(:leave, {}).permit(:leave_to,:leave_from,:leave_type,:comment,:image)
    end
end
