#!/usr/bin/env ruby
# bin/generate_file_structure
#
# Usage:
#   chmod +x bin/generate_file_structure
#   ./bin/generate_file_structure [OUTPUT_PATH]
#
# Defaults to writing ./file_structure.md

require 'pathname'

# where to write
output = ARGV.first || 'file_structure.md'
root   = Pathname.pwd

# helper to skip hidden and vendor
def skip?(path)
  parts = path.each_filename.to_a
  # skip hidden files/folders, vendor, or the Gentile.lock file
  parts.any? { |p| p.start_with?('.') } ||
    parts.include?('vendor') ||
    path.basename.to_s == 'Gemfile.lock' ||
    path.basename.to_s == 'generate_content.rb' ||
    path.basename.to_s == 'LICENSE'
end

File.open(output, 'w') do |md|
  Dir.glob('**/*', File::FNM_DOTMATCH).sort.each do |rel|
    next if rel == '.' || rel == '..'
    path = root + rel
    next unless path.file?
    next if skip?(path)

    md.puts "File: #{rel}"
    md.puts "```#{path.extname.sub(/^\./, '')}"
    md.write File.read(path)
    md.puts "\n```"
    md.puts
  end
end

puts "✅ Wrote file structure to #{output}"
