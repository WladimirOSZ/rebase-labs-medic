require_relative 'csv_importer'

class Enqueuer
  def self.enqueue(csv)
    puts 'Enqueuing...'
    CsvImporter.perform_async(csv)
    puts 'Enqueued!'
  end
end
