class PasswordsMailer < Merb::MailController
  def create
    @user = params[:user]
    render_mail
  end
end
