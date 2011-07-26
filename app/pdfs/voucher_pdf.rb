# -*- encoding: utf-8 -*-
class VoucherPDF < Prawn::Document
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper

  def initialize(vouchers)
    @vouchers = vouchers
    super(:page_size=>'A4')
  end

  def to_pdf
    @vouchers[0..-2].each do |v|
      render_voucher(v)
      start_new_page
    end
    render_voucher(@vouchers[-1])
    render
  end

  def render_voucher(voucher)

    font_families.update( "Arial" => {
      :normal=>"#{Rails.root}/fonts/Arial.ttf",
      :bold=>"#{Rails.root}/fonts/Arial_Bold.ttf",
      :italic=>"#{Rails.root}/fonts/Arial_Italic.ttf",
      :bold_italic=>"#{Rails.root}/fonts/Arial_Bold_Italic.ttf"
    }
    )
    font("Arial")
    define_grid(:columns=>6,:rows=>45)


    text "#{Mage::Application.settings[:organization_name]} (#{voucher.organ})", :align=>:center, :size=>18, :style=>:bold
    stroken_box grid([1,0],[2,1]) do
      text "Transaktionsdatum:", :size=>10, :style=>:bold
      move_down(2)
      text I18n.l(voucher.accounting_date.to_date), :size=>16, :align=>:right
    end
    stroken_box grid([1,2],[2,3]) do
      text "Beskrivning:", :size => 10, :style=>:bold
      text_box voucher.title,:at=>[0,cursor], :size=>16, :align=>:center, :overflow=>:shrink_to_fit
    end
    stroken_box grid([1,4],[2,5]) do
      text "Verifikat Nr:", :size => 10, :style=>:bold
      move_down(2)
      text voucher.pretty_number, :size=>16, :align=>:right, :style=>:bold
    end
    stroken_box grid([3,0],[4,1]) do
      if voucher.corrects?
        text "Rättar verifikat:", :size=>14,:style=>:bold_italic
        text voucher.corrects.pretty_number, :size=>16, :align=>:right,:style=>:bold
      end
    end
    stroken_box grid([3,2],[4,5]) do 
      text "Bokfört av:", :size=>14,  :style=>:bold_italic
      text_box voucher.created_by.name,:at=>[0,cursor], :size=>16, :align=>:right, :overflow=>:shrink_to_fit
    end

    stroken_box grid([5,0],[33,1]) do
      text "Kvitto:", :size=>14, :style=>:bold
    end

    stroken_box grid([34,0],[43,1]) do
      qr = RQRCode::QRCode.new(Rails.application.routes.url_helpers.voucher_url(voucher),:size=>5,:level=>:l)
      bounding_box([11,10],:width=>100) do
        qrcode(qr,4,1)
      end
    end

    # Rader

    table_data = voucher.voucher_rows.map do |r|
        d = [
          r.account.number,
          r.arrangement.to_s,
          currency(r.debet).to_s.to_str, #Workaround for nil and then errors when doing in place
          currency(r.kredit).to_s.to_str, #modififications on a html_safe string..
          r.signed? ? "#{I18n.l r.created_at.to_date, :format=>:slash_notation} #{r.signature.initials}" : ""
        ]
        if r.canceled?
          d[0..-2].map { |i| "<strikethrough>#{i}</strikethrough>" } + [d[-1]] # Don't strike last
        else 
          d
        end
    end

    #Insert header:
    table_data.insert(0,[
      "Konto",
      "Arrangemang",
      "Debet",
      "Kredit",
      ""
    ])

    if table_data.length < 33
      (33 - table_data.length).times do 
        table_data << ["","","","",""]
      end
    end
    
    font_size(10)

    grid([5,2],[43,5]).bounding_box do
      stroke_bounds
      wf = bounds.width/100 #width fraction
      table table_data, 
          :row_colors => ['dddddd','ffffff'], 
          :column_widths => [11*wf, 33*wf,19*wf, 19*wf, 18*wf] ,
          :cell_style => {:height=>20.21},
          do |t|
            t.rows(0).font_style = :bold
            t.columns(2..3).align = :right
            t.columns(0..4).style(:overflow => :shrink_to_fit,:inline_format=>true)
            t.rows(0).columns(0..4).align = :center
          end
    end
  end

  def stroken_box(g, options={}, &block) 
    g.bounding_box {
      stroke_bounds
      bounds.add_right_padding(2)
      bounds.add_left_padding(2)
      pad_top(3) do
        block.call
      end
    }
  end
end
