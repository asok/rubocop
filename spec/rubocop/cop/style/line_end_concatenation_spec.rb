# encoding: utf-8

require 'spec_helper'

describe Rubocop::Cop::Style::LineEndConcatenation do
  subject(:cop) { described_class.new }

  it 'registers an offense for string concat at line end' do
    inspect_source(cop,
                   ['top = "test" +',
                    '"top"'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for dynamic string concat at line end' do
    inspect_source(cop,
                   ['top = "test#{x}" +',
                    '"top"'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'accepts string concat on the same line' do
    inspect_source(cop,
                   ['top = "test" + "top"'])
    expect(cop.offenses).to be_empty
  end

  it 'accepts string concat at line end when followed by comment' do
    inspect_source(cop,
                   ['top = "test" + # something',
                    '"top"'])
    expect(cop.offenses).to be_empty
  end

  it 'autocorrects by replacing + with \\' do
    corrected = autocorrect_source(cop,
                                   ['top = "test" +',
                                    '"top"'])
    expect(corrected).to eq ['top = "test" \\', '"top"'].join("\n")
  end
end
