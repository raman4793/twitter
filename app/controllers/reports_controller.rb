class ReportsController < ApplicationController
  def create
    @report = current_user.reports.build(report_params)
    @report.save
  end

  private
  def report_params
    params.require(:report).permit(:user_id, :reported_id, :reason)
  end
end
