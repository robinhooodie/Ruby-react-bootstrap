class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  include Trackable

  def show
    @rooms = Room.where(user_id: @user.id)
                 .order('created_at DESC')
                 .paginate(page: params[:page], per_page: 4)

    @articles = Article.where(user_id: @user.id)
                       .order('created_at DESC')
                       .paginate(page: params[:page], per_page: 12)

    ahoy.track "Viewed User: #{@user.name}", view_user_id: @user.id
  end

  def toggle_theme
    @user.toggle!(:dark_theme)
    render json: { result: true }
  end

  def destroy
    if can? :manage, @user # Prevent inserted delete button as html from working
      @user.destroy
    else
      redirect_to authenticated_root_url, alert: 'You CANNOT delete a user other than yourself. If you want to delete your account, please click on Edit Profile in the top menu.'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
