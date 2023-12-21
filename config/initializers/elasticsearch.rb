# config/initializers/elasticsearch.rb

Elasticsearch::Model.client = Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'] || 'http://localhost:5432', log: true)
