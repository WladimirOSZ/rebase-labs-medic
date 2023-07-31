require 'spec_helper'

describe 'Acessa os testes' do
  it 'e não há dados cadastrados no banco' do
    visit '/tests'
    expect(page).not_to have_content('cpf')
  end

  it 'e visualiza os dados' do
    Database.connect.exec("INSERT INTO patients (cpf, name, email, birthdate, address, city, state) VALUES ('12345678900', 'João', '123@gmail.com', '1990-01-01', 'Rua 1', 'Cidade 1', 'Estado 1')")
    Database.connect.exec("INSERT INTO doctors (crm, crm_state, name, email) VALUES ('123456', 'SP', 'João', '123')")
    Database.connect.exec("INSERT INTO exams (patient_id, doctor_id, token, date) VALUES (1, 1, '1234567890', '1990-01-01')")
    Database.connect.exec("INSERT INTO tests (exam_id, type, limits, result) VALUES (1, 'Tipo 1', 'Limites 1', 'Resultado 1')")
    visit '/tests'
    expect(page).to have_content('cpf')
    expect(page).to have_content('12345678900')
    expect(page).to have_content('João')
    expect(page).to have_content('123@gmail.com')
    expect(page).to have_content('1990-01-01')
    expect(page).to have_content('Rua 1')
    expect(page).to have_content('Cidade 1')
    expect(page).to have_content('Estado 1')
  end
end