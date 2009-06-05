class Themes < Application
  def index
    redirect url(:theme, 1)
  end

  def show
    # TODO: Different visualizations by params[:id]
    render
  end
end
