# -*- encoding: utf-8 -*-
class ReportsController < ApplicationController
  @@report_templates = {:complete =>"Huvudbok redovisning", :summary =>"Huvudbok summerad", :accounts => "Kontorapport"}

  def index
    @report_templates = @@report_templates
  end

  def show
    @report_input = params[:report]
    @report_template = @report_input[:template]
    @report_name = @@report_templates[@report_template.to_sym]

    @series = [Series.find(@report_input[:series])] unless @report_input[:series].empty?
    @activity_year = ActivityYear.find(@report_input[:activity_year])
    @organ = @report_input[:organ].empty? ? nil : Organ.find(@report_input[:organ])

    @report_name += " (filtrerad)" if @series || @organ

    if self.respond_to?(@report_template)
      self.send(@report_template)
    else
      @report = Mage::Report.full_report(@activity_year, @series, @organ)
    end

    render @report_template
  end 

  def summary
    @report = Mage::Report.full_report_summarized(@activity_year, @series, @organ)
  end
end
