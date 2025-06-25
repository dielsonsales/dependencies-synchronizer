require_relative '../logger'

module DependenciesSynchronizer
  module Updater
    class PodfileUpdater
      def initialize(deps)
        @deps = deps
      end

      def update(path)
        text = File.read(path)

        new_text = text.gsub(/^(?<indent>\s*)pod\s+['"](?<name>[^'"]+)['"]\s*,\s*['"][^'"]*['"].*$/) do |line|
          indent  = Regexp.last_match[:indent]
          name    = Regexp.last_match[:name]
          version = @deps.version_for(name)

          if version
            DependenciesSynchronizer::Logger.debug("→ Updating pod '#{name}' to version '#{version}'")
            "#{indent}pod '#{name}', '#{version}'"
          else
            DependenciesSynchronizer::Logger.debug("→ No version found for pod '#{name}', keeping '#{line.strip}'")
            line
          end
        end

        File.write(path, new_text)
      end
    end
  end
end
