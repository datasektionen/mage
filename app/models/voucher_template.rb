#-*- encoding: utf-8 -*-
class VoucherTemplate < ActiveRecord::Base
  has_many :input_fields, :class_name=>"TemplateInputField"
  has_many :output_fields, :class_name=>"TemplateOutputField"

  TYPE_MULTIROW = 0
  TYPE_SINGLEROW = 1

  scope :multirow, where("template_type=#{TYPE_MULTIROW}")
  scope :singlerow, where("template_type=#{TYPE_SINGLEROW}")

  def parse(fields, arr)
    values = Hash.new
    fields.each { |k,f| values[k.to_s] = f.to_f }
    result = Hash.new
    to_parse = output_fields.clone
    last_size = to_parse.size
    until to_parse.empty?
      to_parse.each do |f|
        r = f.parse(values,arr)
        unless r.nil?
          to_parse.delete(f)
          result[f.id] = r unless r.sum == 0 
          values[f.script_name] = r.sum unless f.script_name.nil? or f.script_name.empty?
        end
      end
      if to_parse.size == last_size
        raise "Kunde inte parsa alla template fält, har du cirkelreferenser?. Följande fält är kvar: #{to_parse.inspect}."
      else
        last_size = to_parse.size
      end
    end
    result.sort.map { |i| i[1] }
  end

  def has_arrangements?
    output_fields.any? { |f| f.account.has_arrangements? }
  end
end
