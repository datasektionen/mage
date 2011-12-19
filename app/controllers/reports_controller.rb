# -*- encoding: utf-8 -*-
class ReportsController < ApplicationController
  def index
    @report_templates = {"Redovisning fullständig"=>:complete, "Redovisning summerad"=>:summary}
  end

  def show
    @report_input = params[:report]
    @report_template = @report_input[:template]

    if @report_input[:series].empty?
      @series = Series.accessible_by(current_user)
    else
      @series = [Series.find(@report_input[:series])]
      authorize! :read, @series
    end
    @activity_year = ActivityYear.find(@report_input[:activity_year])
    @conditions = {:activity_year_id=>@report_input[:activity_year]}
    @organ = @report_input[:organ].empty? ? nil : Organ.find(@report_input[:organ])
    @conditions[:organ_id] = @organ.id unless @organ.nil?
    @vouchers = @series.collect { |series| series.vouchers.where(@conditions) }.flatten
    @rows = @vouchers.map { |voucher| voucher.voucher_rows }.flatten

    self.send(@report_template) if self.respond_to?(@report_template)
    render @report_template
  end 

  def complete
    @rows = @rows.group_by(&:arrangement).sort_by {|arr,row| arr.nil? ? -1 : arr.number }
  end

  def summary
    @rows = @rows.group_by(&:arrangement).sort_by {|arr,rows| arr.nil? ? -1 : arr.number }
  end
end
