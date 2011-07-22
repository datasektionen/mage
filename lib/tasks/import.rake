# -*- encoding: utf-8 -*-

desc "Importerar kontoplan"
task :import_kontoplan => :environment do 
  data = ActiveSupport::JSON.decode(File.open("kontoplan.json",'r').read)
  data.each do |d|
    a = Account.create(:number=>d['nr'], :name=>d['name'])
    puts a.inspect
  end
end

desc "Importerar projekt"
task :import_projekt => :environment do 
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
