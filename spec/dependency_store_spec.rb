require 'spec_helper'
require 'tempfile'
require_relative '../lib/dependencies_synchronizer/dependency_store'

describe DependenciesSynchronizer::DependencyStore do
  let(:core_rb_content) do
    <<~RUBY
      def core_dependencies
        dependency('SAAnalytics', '1.1.1', 'repo-url')
        dependency('SANetwork', '1.2.3', 'repo-url')
      end
    RUBY
  end

  def with_core_rb(content)
    file = Tempfile.new('core.rb')
    file.write(content)
    file.rewind
    yield file.path
  ensure
    file.close
    file.unlink
  end

  it 'parses dependencies correctly from Core.rb' do
    with_core_rb(core_rb_content) do |path|
      store = described_class.new(path)
      expect(store.version_for('SAAnalytics')).to eq('1.1.1')
      expect(store.version_for('SANetwork')).to eq('1.2.3')
    end
  end

  it 'returns nil for unknown dependency' do
    with_core_rb(core_rb_content) do |path|
      store = described_class.new(path)
      expect(store.version_for('UnknownDep')).to be_nil
    end
  end
end
