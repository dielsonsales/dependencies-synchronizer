require_relative '../logger'

module DependenciesSynchronizer
  module Updater
    class PackageSwiftUpdater
      def initialize(deps)
        @deps = deps
      end

      def update(path)
        DependenciesSynchronizer::Logger.info("🔍 Updating Package.swift: #{path}")
        text = File.read(path)

        # Build mapping of package name => product name
        package_to_product = {}
        text.scan(/\.product\s*\(\s*name:\s*"([^"]+)",\s*package:\s*"([^"]+)"\s*\)/) do |product, package|
          package_to_product[package] = product
          DependenciesSynchronizer::Logger.debug("Found mapping: #{package} => #{product}")
        end

        # Update exact version constraints in .package(...) entries
        new_text = text.gsub(/\.package\(\s*url:\s*"(?<url>[^"]+)"\s*,\s*exact:\s*"(?<old_ver>[^"]+)"\s*\)/m) do |match|
          url       = Regexp.last_match[:url]
          package   = File.basename(url, ".git")
          product   = package_to_product[package]
          new_ver   = @deps.version_for(product)

          DependenciesSynchronizer::Logger.debug("Checking package '#{package}' (mapped to '#{product}')")

          if new_ver
            DependenciesSynchronizer::Logger.debug("→ Updating '#{package}' to version '#{new_ver}'")
            %Q(.package(url: "#{url}", exact: "#{new_ver}"))
          else
            DependenciesSynchronizer::Logger.debug("→ No update found for '#{product}', keeping '#{match.strip}'")
            match
          end
        end

        File.write(path, new_text)
      end
    end
  end
end
