# -*- encoding: utf-8 -*-

kontotyper = {
  "T" => 1,
  "S" => 2,
  "I" => 3,
  "K" => 4
}

namespace "import" do
  desc "Importerar kontoplan"
  task :kontoplan => :environment do
    data = ActiveSupport::JSON.decode(File.open("kontoplan.json",'r').read)
    data.each do |d|
      a = Account.create(:number=>d['nr'], :name=>d['name'])
      puts a.inspect
    end
  end

  desc "Importerar projekt"
  task :projekt => :environment do
    data = ActiveSupport::JSON.decode(File.open("projekt.json",'r').read)
    data.each do |d|
      a = Arrangement.new(:name=>d['name'],:number=>d['nr'].to_i)
      if a.number < 100
        a.organ = Organ.find_by_name("Mottagningen")
      elsif a.number < 200
        a.organ = Organ.find_by_name("DKM")
      else
        a.organ = Organ.find_by_name("Centralt")
      end
      a.save
      puts a.inspect
    end
  end

  desc "Importerar data från hogia.si. Data som redan finns importeras inte. Kör ./hogiaclean på filen först!"
  task :sie => :environment do |t, args|
    f = File.open("hogia.si",'r')
    lines = f.readlines
    f.close
    
    # Build syntax tree:
    # Root {
    #   { (Line) a, b, c }
    # { (Line) a, { (b, in quotes) }, { (multiline block) {a, b, c}, {d, e, f} }
    # etc

    @tree = Array.new
    @cur_pos = @tree
    @pos_stack = Array.new

    lines.each { |line| parse_line line}
    
    @organ_translate = Hash.new
    @arr_translate = Hash.new

    current_user = nil

    material_from = nil

    @voucher = nil

    # Take care of the result:
    @tree.each do |item|
      if @voucher && item.first.is_a?(Array)
        # Parse transactions
        item.each do |i2|
          case i2.first
            when "TRANS"
              @voucher.voucher_rows << parse_trans(i2)
            when "RTRANS"
              #Ignore for now (until i know how hogia do)
            when "BTRANS"
              #Ignore for now (until i know how hogia do)
          end
        end
        unless @voucher.save
          puts "Kunde inte spara verifikat #{@voucher.pretty_number}: #{@voucher.errors.inspect}"
          exit
        else
          puts "Sparade verifikat #{@voucher.pretty_number}"
          Journal.log(:import,@voucher,current_user)
        end
        @voucher = nil
      end
      # Parse on first:
      case item.first
        when "GEN"
          material_from = User.find_by_initials(item[2])
          current_user = material_from
          if material_from.nil?
            puts "Ogiltlig användarsignatur (#{item[2]}) i importfilen, avbryter."
            exit
          end
        when "KONTO"
          # Add account
          if Account.where(:number=>item[1].to_i).count == 0
            # Create:
            a = Account.create(:number=>item[1],:name=>item[2])
            Journal.log(:import,a,current_user)
          end
        when "KTYP"
          a = Account.find_by_number(item[1].to_i)
          a.account_type = kontotyper[item[2]]
          a.save
          Journal.log(:update_import,a,current_user)
        when "VER"
          # Skapa verifikat
          series = Series.find_by_letter(item[1])
          if series.nil?
            puts "Okänd serie #{item[1]}"
            exit
          end
          vernr = item[2].to_i
          if Voucher.where(:series_id=>series.id,:number=>vernr).count == 1
            puts "Verifikat #{item[1]}#{vernr} finns redan. Avbryter..."
            exit
          end
          @voucher = Voucher.new(:series=>series,:number=>vernr, :accounting_date=>Date.parse(item[3]), :title=>item[4], :bookkept_by =>current_user, :material_from=>material_from, :organ_id => series.default_organ_id)
          y = @voucher.accounting_date.year
          @voucher.activity_year = ActivityYear.find_by_year(y)
          if @voucher.activity_year.nil?
            @voucher.activity_year = ActivityYear.create(:year=>y)
            puts "Skapar aktivitetsår #{y}"
          end
        when "OBJEKT"
          if item[1] == "2" && item[2]!="0"
            o = Organ.find_by_name(item[3])
            if o.nil?
              o = Organ.create(:name=>item[3])
              Journal.log(:import,o,current_user)
            end
            @organ_translate[item[2]] = o
          elsif item[1] == "1" && item[2] != "0"
            # Skapa översättingstabell för projekt => arr
            if Arrangement.find_by_number(item[2]).nil? 
              a = Arrangement.new(:name=>item[3], :number=>item[2].to_i)
              if a.number < 100
                a.organ = Organ.find_by_name("Mottagningen")
              elsif a.number < 200
                a.organ = Organ.find_by_name("DKM")
              else
                a.organ = Organ.find_by_name("Centralt")
              end
              a.save
              Journal.log(:import,a,current_user)
              @arr_translate[item[2]] = a
            else
              @arr_translate[item[2]] = Arrangement.find_by_number(item[2])
            end
          end
      end
    end
  end

private

  def parse_trans(data)
    a = Account.find_by_number(data[1])
    unless a.nil?
      vr = VoucherRow.new(:account=>a, :sum=>data[3].to_i)
      if a.has_arrangements?
        if data[2][3] == "0"
          organ = @voucher.organ
        else
          organ = @organ_translate[data[2][3]]
          if organ.nil?
            puts "Ogilltlig organ #{data[2][3]}"
            exit
          end
          @voucher.organ = organ
        end
        if data[2][1] == "0"
          vr.arrangement = Arrangement.where(:number=>0, :organ_id=>organ.id).first
        else
          vr.arrangement = @arr_translate[data[2][1]]
        end
      end
      vr
    else
      puts "Hittade inte konto #{data[1]}, avbryter"
      exit
    end
  end

  def parse_line(line)
    line.lstrip!
    if line =~ /^#/
      @cur_pos << Array.new 
      @pos_stack.push(@cur_pos)
      @cur_pos = @cur_pos.last
      parse_line line[1..-1]
      @cur_pos = @pos_stack.pop
    else
      line.split.each { |token| parse_token(token) }
    end
  end

  def parse_token(token)
    if token =~ /^""$/
      @cur_pos << ""
    elsif token =~ /^[{"]/
      @cur_pos << Array.new
      @pos_stack.push(@cur_pos)
      @cur_pos = @cur_pos.last
      parse_token(token[1..-1])
    elsif token =~ /[}"]$/
      t = $&
      parse_token(token[0..-2])
      # Insert builded item into parent
      @cur_pos = @pos_stack.pop
      item = @cur_pos.pop
      if t == '"' #string
        item = item.join(" ")
      end
      @cur_pos << item
    elsif token.length > 0
      @cur_pos << token
    end
  end

end
