
class ProductsController < ApplicationController

  before_action :require_admin, except: [ :show ]

  def index
    @products = Product.order("created_at asc").page(params[:page]).per(6)
  end

  def show
    @product = Product.find(params[:id])
    @products = Product.order("created_at desc").page(params[:page]).per(4)
    @brand = @product.brand
  end

  def new
    @product = current_brand.products.new
    # 8.times { @product.images.build }
  end

  def edit
    @product = Product.find(params[:id])
    @product.images.build if @product.images.empty?
  end

  def create
    @product = current_brand.products.new(product_params)
    @product.owner = current_user
    @image = @product.images.build
    @image.image = params[:product][:image][:image]

    if @product.save
      redirect_to [current_brand, @product]
    else
      # (8 - @product.images.size).times { @product.images.build }
      format.html { render action: "new" }
    end
  end

  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to [current_brand, @product], notice: 'Product was successfully updated.' }
      else
        @product.images.build if @product.images.empty?
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @product = current_brand.products.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
    end
  end

  private

    def current_brand
      @brand ||= Brand.find(params[:brand_id])
    end

    def product_params
      params.require(:product).
              permit( :name, :description, :details, :price, :deliver_date, :updates, :status, :owner,
                      brand_attributes: [ :name, :profile ],
                      images_attributes: [:id, :image, :imageable_id, :imageable_type, :_destroy] )
    end

end
