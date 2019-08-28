class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:is_hr]
  before_action :is_hr , only: [:index,:new_employees_list,:all_employees_leaves_list,:new_leaves]

  # GET /users
  # GET /users.json
  def index
     @users = User.where.not(designation: "hr").all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        
        
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def is_hr
    if user_signed_in?
    user_details_obj = User.select(:designation).where(id:current_user.id)
    user_designation = user_details_obj[0].designation
    if user_designation != "hr"
      redirect_to leaves_path , notice: 'Access Denied.'
    end
  else
    redirect_to root_path, notice: 'Please Sign In Before Access.'
  end    
  end

  def new_employees_list
     @new_employees = User.where.not(designation:"hr").where(status:"inactive")
  end

  def all_employees_leaves_list
    
    @all_employees_leaves = Leave.all  
  end

  def approve_employees_leaves
    employee_id = params[:id] if params[:id].present?
    leave_taken_from = params[:leave_from] if params[:leave_from].present?
    leave_taken_to = params[:leave_to] if params[:leave_to].present?
    puts @leave_taken_to.to_json
    employee_details = User.where(id: employee_id.to_i)
    employee_email = employee_details[0].email
    UserMailer.approve_employee_leave(employee_email,leave_taken_from,leave_taken_to).deliver_now
    Leave.where(user_id:employee_id.to_i).where(leave_to:leave_taken_to).where(leave_from:leave_taken_from).update(status:"approved")
    redirect_to users_path
    
  end

  def decline_employees_leaves
    employee_id = params[:id] if params[:id].present?
    leave_taken_from = params[:leave_from].to_s if params[:leave_from].present?
    leave_taken_to = params[:leave_to].to_s if params[:leave_to].present?
    puts @leave_taken_from.to_json
   
    
    employee_details = User.where(id: employee_id.to_i)
    employee_email = employee_details[0].email
    UserMailer.decline_employee_leave(employee_email,leave_taken_from,leave_taken_to).deliver_now
    Leave.where(user_id:employee_id.to_i).where(leave_to:leave_taken_to).where(leave_from:leave_taken_from).update(status:"declined")
    redirect_to users_path
    
  end
  

  def activate_employees_status
      employee_id = params[:id] if params[:id].present?
      puts employee_id.to_json
      employee_details = User.where(id: employee_id.to_i)
      employee_email = employee_details[0].email
      UserMailer.approve_employee_status(employee_email).deliver_now
      User.where(id:employee_id.to_i).update(status:"active")
      redirect_to users_path
      
  end

  def search_employees_data
    search_term = params[:search_term] if params[:search_term].present?
    employees_data = User.where.not(designation: "hr").where(status: "#{search_term}")
    render :json=> employees_data
  end

  def search_employees_leaves_status
    search_term = params[:search_term] if params[:search_term].present?
    employees_leaves_data = Leave.where(status: "#{search_term}")
    render :json=> employees_leaves_data
  end

  def new_leaves
    @new_leaves = Leave.where(status:"onhold")
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.fetch(:user, {}).permit(:email, :name, :designation,:password, :current_password)
    end
end
