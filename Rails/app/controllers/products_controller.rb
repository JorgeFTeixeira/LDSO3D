class ProductsController < ApplicationController
	before_action :set_product, only: [:show, :edit, :update, :destroy]
	def index
		@products = Product.all
		@catalog = Catalog.first
		@locale = params[:locale]
	end

	def show
		@product = Product.find(params[:id])
		@locale = params[:locale]
	end

	def new	
		@product = Product.new
		3.times do
		    experience = @product.experiences.build
		end
	end

	def edit
		@product = Product.find(params[:id])
	end

	def create
	    @product = Product.new(product_params)
	    
	    if @product.save
	      redirect_to @product
	    else
		  render 'new'
		end

	end

	def update
	  @product = Product.find(params[:id])
	 
	  if @product.update(product_params)
	    redirect_to @product
	  else
	    render 'edit'
	  end
	end

	private 
	    def set_product
	      @product = Product.find(params[:id])
	    end

		def product_params
			params.require(:product).permit(:name_pt, :description_pt, :name_en, :description_en, :image, experiences_attributes: [ :id, :name_pt, :name_en, :_destroy ])
		end

end