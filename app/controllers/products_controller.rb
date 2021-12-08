class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  require 'csv'

  # GET /products or /products.json
  def index
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products/file_upload
  def upload
    file = params[:product][:file]
    puts file.inspect 
    File.open(Rails.root.join('public', 'uploads', file.original_filename), 'wb') do |f|
      f.write(file.read)
    end

    # Arrume um jeito de pegar o caminho relativo
    # Uma alternativa preguiçosa seria tu salvar o caminho do teu app em uma ENV
    # E usar da seguinte forma "ENV['nome_da_var']/public/uploads"
    file_path = "/home/rafael/Documentos/RubyOnRails/CSVUploader/public/uploads/#{file.original_filename}"
    file = CSV.read(file_path)
    file.each do |title, description, value, brand|
      # Caso queira fazer um debug
      # puts "#{title}, #{description}, #{cost}, #{brand}"
      if title != 'title'
        @product = Product.create(title: title, description: description, value: value)
      end
    end

    File.delete(file_path) if File.exist?(file_path)

    redirect_to products_path
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:title, :description, :value, :file)
    end
end
