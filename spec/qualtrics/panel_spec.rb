require 'spec_helper'

describe Qualtrics::Panel do
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
end