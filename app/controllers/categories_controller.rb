class CategoriesController < ApplicationController

  def new
    @category = Category.new

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "Categoria foi criada com sucesso." }
        format.html { redirect_to categories_path, notice: "Categoria foi criada com sucesso." }
      end
    else
      @categories = Category.all
      render :index
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    @categories = Category.all

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Categoria foi deletada com sucesso." }
    end
  end

  private

  def category_params
    params.require(:category).permit(:title, :description)
  end
end
