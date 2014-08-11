# -*- encoding: utf-8 -*-
class ReportsController < ApplicationController
  @@report_templates = {:complete =>"Huvudbok redovisning", :summary =>"Huvudbok summerad", :balance=>"Balansrapport", :result=>"Resultatrapport", :accounts=>"Kontorapport"}

  def index
    @report_templates = @@report_templates
  end

  def show
    @report_input = params[:report]
    @report_template = @report_input[:template]
    @report_name = @@report_templates[@report_template.to_sym]

    @series = Series.find(@report_input[:series]) unless @report_input[:series].empty?
    @account = Account.find(@report_input[:account]) unless @report_input[:account].empty?
    @activity_year = ActivityYear.find(@report_input[:activity_year])
    @organs = Array(@report_input[:organ]).select(&:present?).map { |o| Organ.find(o) }
    @organs = nil if @organs.blank?

    @report_name += " (filtrerad)" if @series || @organs

    if self.respond_to?(@report_template)
      self.send(@report_template)
    else
      @report = Mage::Report.full_report(@activity_year, @series, @organs, @account)
      render @report_template
    end

  end

  def summary
    @report = Mage::Report.full_report_summarized(@activity_year, @series, @organs, @account)
    render @report_template
  end

  # Den här rapporten saknar vy än så länge, användes för att ta fram data till resturangrapporten
  # Ska summera per konto utan några arrangemang eller dyl
  def accounts
    @report = Mage::Report.account_report(@activity_year, @series, @organs, @account, nil , false)
    @hide_arrangement = true
    render :summary
  end

  def balance
    @report = Mage::Report.full_report_summarized(@activity_year, @series, @organs, @account, [Account::ASSET_ACCOUNT, Account::DEBT_ACCOUNT], false)
    @hide_arrangement = true
    render :summary
  end

  def result
    @report = Mage::Report.full_report_summarized(@activity_year, @series, @organs, @account, [Account::INCOME_ACCOUNT, Account::COST_ACCOUNT], true)
    render :summary
  end
end
