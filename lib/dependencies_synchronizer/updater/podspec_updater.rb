require_relative '../logger'

module DependenciesSynchronizer
  module Updater
    class PodspecUpdater
      def initialize(deps)
        @deps = deps
      end

      def update(path)
        DependenciesSynchronizer::Logger.info("🔍 Updating podspec: #{path}")
        text = File.read(path)

        new_text = text.gsub(/^(?<indent>\s*)s\.dependency\s+['"](?<name>[^'"]+)['"]\s*,.*$/) do |line|
          indent  = Regexp.last_match[:indent]
          name    = Regexp.last_match[:name]
          version = @deps.version_for(name)

          DependenciesSynchronizer::Logger.debug("Checking s.dependency '#{name}' in podspec")

          if version
            truncated = version.split('.')[0..1].join('.')
            DependenciesSynchronizer::Logger.debug("→ Updating '#{name}' to '~> #{truncated}'")
            "#{indent}s.dependency '#{name}', '~> #{truncated}'"
          else
            DependenciesSynchronizer::Logger.debug("→ No update found for '#{name}', keeping line unchanged")
            line
          end
        end

        File.write(path, new_text)
      end
    end
  end
end
