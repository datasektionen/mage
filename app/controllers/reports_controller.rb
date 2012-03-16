# -*- encoding: utf-8 -*-
class ReportsController < ApplicationController
  def index
    @report_templates = {"Huvudbok"=>:complete, "Huvudbok summerad"=>:summary, "Kontorapport"=>:accounts}
  end

  def show
    self.class.benchmark("input") do 
      @report_input = params[:report]
      @report_template = @report_input[:template]

      @series = [Series.find(@report_input[:series])] unless @report_input[:series].empty?
      @activity_year = ActivityYear.find(@report_input[:activity_year])
      @organ = @report_input[:organ].empty? ? nil : Organ.find(@report_input[:organ])
    end

    self.class.benchmark("build report") do
      if self.respond_to?(@report_template)
        self.send(@report_template)
      else
        @report = Mage::Report.full_report(@activity_year, @series, @organ)
      end
    end

    render @report_template
  end 

  def summary
    @report = Mage::Report.full_report_summarized(@activity_year, @series, @organ)
  end
end
