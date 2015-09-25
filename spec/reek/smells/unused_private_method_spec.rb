require_relative '../../spec_helper'
require_lib 'reek/smells/unused_private_method'
require_relative 'smell_detector_shared'

RSpec.describe Reek::Smells::UnusedPrivateMethod do
  let(:detector) { build(:smell_detector, smell_type: :UnusedPrivateMethod) }

  it_should_behave_like 'SmellDetector'

  context 'unused private methods' do
    it 'reports instance methods' do
      source = <<-EOF
        class Car
          private
          def start_the_engine; end
        end
      EOF

      expect(source).to reek_of(:UnusedPrivateMethod, name: :start_the_engine)
    end

    it 'reports class methods' do
      source = <<-EOF
        class Car
          class << self
            private
            def start_the_engine; end
          end
        end
      EOF

      expect(source).to reek_of(:UnusedPrivateMethod, name: :start_the_engine)
    end

    xit 'ignores differences between class and instance methods' do
      source = <<-EOF
        class Car
          def drive
            start_the_engine
          end

          class << self
            private
            def start_the_engine; end
          end

          private
          def start_the_engine; end
        end
      EOF

      expect(source).to reek_of(:UnusedPrivateMethod, name: :start_the_engine)
    end

    it 'creates warnings correctly' do
      source = <<-EOF
        class Car
          class << self
            private
            def start_the_engine; end
          end

          private

          def bar; end
        end
      EOF

      ctx = create_context(source)
      warnings = detector.examine_context(ctx)
      first_warning = warnings.first
      expect(first_warning.smell_category).to eq(Reek::Smells::UnusedPrivateMethod.smell_category)
      expect(first_warning.smell_type).to eq(Reek::Smells::UnusedPrivateMethod.smell_type)
      expect(first_warning.parameters[:name]).to eq(:start_the_engine)
      expect(first_warning.lines).to eq([4])

      second_warning = warnings.last
      expect(second_warning.smell_category).to eq(Reek::Smells::UnusedPrivateMethod.smell_category)
      expect(second_warning.smell_type).to eq(Reek::Smells::UnusedPrivateMethod.smell_type)
      expect(second_warning.parameters[:name]).to eq(:bar)
      expect(second_warning.lines).to eq([9])
    end
  end

  context 'used private methods' do
    it 'are not reported' do
      source = <<-EOF
        class Car
          def drive
            start_the_engine
          end

          private
          def start_the_engine; end
        end
      EOF

      expect(source).not_to reek_of(:UnusedPrivateMethod)
    end
  end

  context 'unused protected methods' do
    it 'are not reported' do
      source = <<-EOF
        class Car
          protected
          def start_the_engine; end
        end
      EOF

      expect(source).not_to reek_of(:UnusedPrivateMethod)
    end
  end

  context 'unused public methods' do
    it 'are not reported' do
      source = <<-EOF
        class Car
          def start_the_engine; end
        end
      EOF

      expect(source).not_to reek_of(:UnusedPrivateMethod)
    end
  end
end
