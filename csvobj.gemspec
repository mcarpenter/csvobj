
Gem::Specification.new do |s|
  s.authors = [ 'Martin Carpenter' ]
  s.date = Time.now.strftime('%Y/%m/%d')
  s.description = "CSVobj provides a legible and maintainable mechanism to manipulate CSV files by creating an array of objects from a file or string of CSV information. The resulting object's attributes are defined dynamically and are based on the CSV column name."
  s.email = 'martin.carpenter@gmail.com'
  s.extra_rdoc_files = %w{ LICENSE Rakefile README.rdoc }
  s.files = FileList[ 'lib/**/*', 'test/**/*' ].to_a
  s.has_rdoc = true
  s.homepage = 'http://mcarpenter.org/projects/csvobj'
  s.licenses = [ 'BSD' ]
  s.name = 'csvobj'
  s.platform = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = nil
  s.summary = 'Convert CSV files to an array of objects with friendly "column name" attributes'
  s.test_files = FileList[ "{test}/**/*test.rb" ].to_a
  s.version = '1.0'
end

