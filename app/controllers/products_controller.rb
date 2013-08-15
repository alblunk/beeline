class ProductsController < ApplicationController
  
  before_action :authenticate_user!, except: [ :index, :show ]

  # GET /products
  # GET /products.json
  def index
    @products = Product.order("created_at asc").page(params[:page]).per(6)
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    @products = Product.order("created_at desc").page(params[:page]).per(4)

    respond_to do |format|
      format.html # show.html.erb
      # format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = current_brand.products.new
    @product.images.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = current_brand.products.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = current_brand.products.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        @product.images.build if @product.images.empty?

        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = current_brand.products.find(params[:id])

    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = current_brand.products.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  private

    def current_brand
      @brand ||= Brand.find(params[:brand_id])
    end

    def product_params
      params.require(:product).
              permit(:name, :name, :description,
                      brand_attributes: [ :name, :profile ],
                      images_attributes: [ :image ] )
    end

end
