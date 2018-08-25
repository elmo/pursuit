class PursuitMetricsController < ApplicationController
  before_action :set_pursuit_metric, only: [:show, :edit, :update, :destroy]

  # GET /pursuit_metrics
  # GET /pursuit_metrics.json
  def index
    @pursuit_metrics = PursuitMetric.all
  end

  # GET /pursuit_metrics/1
  # GET /pursuit_metrics/1.json
  def show
  end

  # GET /pursuit_metrics/new
  def new
    @pursuit_metric = PursuitMetric.new
  end

  # GET /pursuit_metrics/1/edit
  def edit
  end

  # POST /pursuit_metrics
  # POST /pursuit_metrics.json
  def create
    @pursuit_metric = PursuitMetric.new(pursuit_metric_params)

    respond_to do |format|
      if @pursuit_metric.save
        format.html { redirect_to @pursuit_metric, notice: 'Pursuit metric was successfully created.' }
        format.json { render :show, status: :created, location: @pursuit_metric }
      else
        format.html { render :new }
        format.json { render json: @pursuit_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pursuit_metrics/1
  # PATCH/PUT /pursuit_metrics/1.json
  def update
    respond_to do |format|
      if @pursuit_metric.update(pursuit_metric_params)
        format.html { redirect_to @pursuit_metric, notice: 'Pursuit metric was successfully updated.' }
        format.json { render :show, status: :ok, location: @pursuit_metric }
      else
        format.html { render :edit }
        format.json { render json: @pursuit_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pursuit_metrics/1
  # DELETE /pursuit_metrics/1.json
  def destroy
    @pursuit_metric.destroy
    respond_to do |format|
      format.html { redirect_to pursuit_metrics_url, notice: 'Pursuit metric was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pursuit_metric
      @pursuit_metric = PursuitMetric.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pursuit_metric_params
      params.require(:pursuit_metric).permit(:date, :account_id, :custom, :earnings)
    end
end
