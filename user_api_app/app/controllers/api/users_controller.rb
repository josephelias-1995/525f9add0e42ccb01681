class Api::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user
    else
      render json: "Failed to create."
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: "Failed to update."
    end
  end

  def destroy
    user_name = @user.firstName
    @user.destroy
    render json: "Deleted user #{user_name}"
  end

  def match_typeahead
    # query = "SELECT COUNT * FROM 'users' WHERE (firstName LIKE '%'ma'%' OR lastName like '%'cu'%'))"
    # @matched_names = User.find_by_sql query
    searchterm = params[:input]
    @matched_users = User.any_of({ :firstName => /.*#{searchterm}.*/ } || { :lastName => /.*#{searchterm}.*/ } || { :email => /.*#{searchterm}.*/ })
    if @matched_users.count > 0
      render json: @matched_users.pluck(:firstName)
    else
      render json: "No matches foud for search term #{searchterm}"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      begin
        @user = User.find(params[:id].to_i)
      rescue Exception => e
        return render json: "Failed to find user."
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:users).permit(:_id, :firstName, :lastName, :email)
    end

end
