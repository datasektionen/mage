module Mage
  module Reports
    class OrganReport
      attr_reader :organ
      attr_accessor :arrangement_reports

      def initialize(organ)
        @organ = organ
        @arrangement_reports = []
      end

      ##
      # data: A hash with the data
      def self.generate(organ, data) 
        report = new(organ)
        
        current_data = []
        current_arr = {:id=>data.first["arrangements.id"], :name=>data.first["arrangements.name"]}

        puts "organ: #{organ.inspect}"

        data.each do |d|
          if current_arr[:id] != d["arrangements.id"]
            #Set whole arr to nil if id was nil
            current_arr = nil if current_arr[:id].nil?
            report.arrangement_reports << ArrangementReport.generate(current_arr, current_data)
            current_data = [d]
            current_arr = {:id=>d["arrangements.id"], :name=>d["arrangements.name"] }
          else
            current_data << d
          end
        end
        report.arrangement_reports << ArrangementReport.generate(current_arr, current_data)

        report
      end
    end
  end
end
