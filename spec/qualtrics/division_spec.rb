require 'spec_helper'

describe Qualtrics::Division, :vcr => true  do

  it 'has a division name' do
    division_name = 'Divison_name'
    division = Qualtrics::Division.new({
      name: division_name
    })
    expect(division.name).to eq(division_name)
  end

  context 'creating to qualtrics' do

    let(:division) do
      Qualtrics::Division.new({
        name: 'Division Test'
      })
    end
    
    it 'populates the division_id when successful' do
      division.create

      expect(division.id).to_not be_nil
    end
  end

end
