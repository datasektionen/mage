desc "Importerar kontoplan"
task :import_kontoplan => :environment do 
  data = ActiveSupport::JSON.decode(File.open("kontoplan.json",'r').read)
  data.each do |d|
    a = Account.create(:number=>d['nr'], :name=>d['name'])
    puts a.inspect
  end
end
