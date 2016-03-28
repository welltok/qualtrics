require 'spec_helper'

describe Qualtrics::DivisionUser, :vcr => true  do

  let(:division) do
    Qualtrics::Division.new({
      name: 'Division Test'
      })
  end

  let(:division_user) do
    Qualtrics::DivisionUser.new({
      username: 'division_user',
      user_password: '123456',
      first_name: 'Division',
      last_name: 'User',
      email: 'division_user@test.com',
      type: 'UT_3dBUKOs5wAT2mLW',
      division_id: division.id
      })
  end

  it 'has a username' do
    division.create
    expect(division_user.username).to eq('division_user')
  end

  it 'has a user_password' do
    division.create    
    expect(division_user.user_password).to eq('123456')
  end

  it 'has a first_name' do
    division.create    
    expect(division_user.first_name).to eq('Division')
  end

  it 'has a last_name' do
    division.create    
    expect(division_user.last_name).to eq('User')
  end

  it 'has a email' do
    division.create    
    expect(division_user.email).to eq('division_user@test.com')
  end

  it 'has a type' do
    division.create    
    expect(division_user.type).to eq('UT_3dBUKOs5wAT2mLW')
  end

  it 'has a division_id' do
    division.create    
    expect(division_user.division_id).to eq(division.id)
  end

  context 'creating to qualtrics' do      
    it 'populates the division_user id when successful' do
      division.create
      division_user.create

      expect(division_user.id).to_not be_nil
    end
  end

end
