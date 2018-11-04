class PumsController < ApplicationController
  before_action :set_pum, only: [:show, :edit, :update, :destroy]
  #before_action :set_date_ranges

  def index
    #TODO ad date filters
    @start_date = (params[:start_date].present?) ? Chronic.parse(params[:start_date]) : Chronic.parse(Date.today - 1.week)
    @end_date = (params[:end_date].present?) ? Chronic.parse(params[:end_date]) : Chronic.parse(Date.today)
    @report = params[:report] || 'one'
    scope = Pum.where(["date >= ? and date <= ?", @start_date, @end_date] )
    scope = scope.where(label: params[:label]              ) if params[:label].present?
    scope = scope.where(account_id: params[:account_id]    ) if params[:account_id].present?
    scope = scope.where(campaign_id: params[:campaign_id]  ) if params[:campaign_id].present?
    scope = scope.where(ad_group_id: params[:ad_group_id]  ) if params[:ad_group_id].present?
    scope = scope.where(keyword_id: params[:keyword_id] ) if params[:keyword_id].present?
    scope = scope.where(publisher:  params[:publisher]  ) if params[:publisher].present?
    scope = scope.where(account_name:  params[:account_name]   ) if params[:account_name].present?
    scope = scope.where(campaign_name:  params[:campaign_name] ) if params[:campaign_name].present?
    scope = scope.where(ad_group_name:  params[:ad_group_name] ) if params[:ad_group_name].present?
    scope = scope.where(keyword: params[:key_word]              ) if params[:key_word].present?
    scope = scope.where(focus_word: params[:focus_word]        ) if params[:focus_word].present?
    scope = scope.where(industry:  params[:industry]           ) if params[:industry].present?
    scope = scope.where(device_type:  params[:device_type]     ) if params[:device_type].present?

    @sort_order = params[:sort_order] || 'asc'
    @next_sort_order = (@sort_order == 'desc') ? 'asc' : 'desc'
    @sort_property =  params[:sort_property] || 'date'

    if params[:format] == "csv"
      @pums = scope.order( { @sort_property => @sort_order } )
    else
      @pums = scope.page(params[:page]).order( { @sort_property => @sort_order } ).per(20)
    end
    if params[:export].present?
      Pum.send_report_to_google_drive(@pums)
    end
    respond_to do |format|
      format.html
      format.csv do
        send_data @pums.to_csv, filename: "pursuit-media-#{Date.today.strftime("%m-%d-%Y")}.csv"
      end
    end
  end

  private

  def set_date_ranges
    @start_date = (params[:report].present?) ? Chronic.parse("#{params[:report]["start_date(1i)"]}-#{params[:report]["start_date(2i)"]}-#{params[:report]["start_date(3i)"]}").utc.beginning_of_day : Date.today - 7.days
    @end_date = (params[:report].present?) ? Chronic.parse("#{params[:report]["end_date(1i)"]}-#{params[:report]["end_date(2i)"]}-#{params[:report]["end_date(3i)"]}").utc.end_of_day : Date.today
    @start_date = Chronic.parse(params[:start_date]).utc.beginning_of_day  - 3.days if params[:start_date].present?
    @end_date = Chronic.parse(params[:end_date]).utc.at_end_of_day + 1.day if params[:end_date].present?
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_pum
      @pum = Pum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pum_params
      params.require(:pum).permit(:date, :label, :account_id, :campaign_id, :ad_group_id, :keyword_id, :publisher, :account_name, :campaign_name, :ad_group_name, :keyword, :focus_word, :industry, :device_type, :impressions, :cost_per_click, :cost, :click_count, :total_unreconciled_revenue, :total_clickout_revenue, :leads, :clickouts, :lead_users, :lead_request_users)
    end
end
