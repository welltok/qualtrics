require 'spec_helper'

describe Qualtrics::Panel, :vcr => true  do
  it 'has a name' do
    name = 'New Panel'
    panel = Qualtrics::Panel.new({
      name: name
    })
    expect(panel.name).to eq(name)
  end

  it 'has a category' do
    category = 'Amazing Category'
    panel = Qualtrics::Panel.new({
      category: category
    })
    expect(panel.category).to eq(category)
  end

  it 'has a library id' do
    library_id = '1'
    panel = Qualtrics::Panel.new({
      library_id: library_id
    })
    expect(panel.library_id).to eq(library_id)
  end

  it 'defaults to the configured library id when none is specified' do
    panel = Qualtrics::Panel.new
    expect(panel.library_id).to eq(Qualtrics.configuration.default_library_id)
  end

  context 'persisting to qualtrics' do
    let(:panel) do   
      Qualtrics::Panel.new({
        name: 'Newest Panel',
        category: 'Great Category'
      })
    end

    it 'persists to qualtrics' do
      expect(panel.save).to be true
    end

    it 'populates the panel_id when successful' do
      panel.save
      expect(panel.id).to_not be_nil
    end

    it 'populates the success attribute' do
      panel.save
      expect(panel).to be_success
    end
  end
end