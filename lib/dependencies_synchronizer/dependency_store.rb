require_relative 'logger'

module DependenciesSynchronizer
  class DependencyStore
    attr_reader :deps

    DEPENDENCY_REGEX = %r{
      dependency\(
        \s*['"](?<name>[^'"]+)['"]\s*,     # name
        \s*['"](?<version>[^'"]+)['"]\s*,  # version
        \s*['"][^'"]*['"]\s*               # source (ignored)
      \)
    }x

    def initialize(core_rb_path)
      DependenciesSynchronizer::Logger.debug("Parsing Core.rb with regex: #{core_rb_path}")
      text = File.read(core_rb_path)

      @deps = text.scan(DEPENDENCY_REGEX).to_h

      if @deps.empty?
        DependenciesSynchronizer::Logger.info("⚠️ No dependencies found via regex in Core.rb")
      else
        DependenciesSynchronizer::Logger.debug("Collected dependencies:")
        @deps.each do |name, version|
          DependenciesSynchronizer::Logger.debug("→ #{name} @ #{version}")
        end
      end
    end

    def version_for(name)
      deps[name]
    end
  end
end
