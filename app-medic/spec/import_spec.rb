require 'spec_helper'

describe 'E importa os dados' do
  it 'através do arquivo de importação' do
    visit '/import'

    conn = Database.connect
    res = conn.exec('SELECT count(*) FROM exams')
    conn.close

    expect(res[0]['count'].to_i).to eq(300)
  end
end