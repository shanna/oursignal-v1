class Static < Application
  def show
    render :template => 'static' / params[:path_as_page]
  end

  def monit
    render 'Hello monit!', :layout => false
  end
end
