require 'find'

module DependenciesSynchronizer
  module FindCard
    DEPENDENCY_REGEX = %r{
      dependency\(
        \s*['"]([^'"]+)['"]\s*,   # name
        \s*['"]([^'"]+)['"]\s*,   # version
        \s*['"]([^'"]+)['"]\s*    # source (ignored)
      \)
    }x

    def self.display_dependencies(dir)
      unless File.directory?(dir)
        abort "❌ Not a directory: #{dir}"
      end

      core_paths = []
      Find.find(dir) { |path| core_paths << path if File.basename(path) == 'Core.rb' }

      if core_paths.empty?
        puts "🔍 No Core.rb found under #{dir}"
        exit 1
      end

      core_paths.each do |core_rb|
        puts "\n✅ Found: #{core_rb}"
        deps = File.read(core_rb).scan(DEPENDENCY_REGEX).map { |name, ver, _| [name, ver] }

        if deps.empty?
          puts "   • No dependencies found."
        else
          puts "   • Dependencies:"
          deps.each { |name, ver| puts "       – #{name} @ #{ver}" }
        end
      end
    end
  end
end
