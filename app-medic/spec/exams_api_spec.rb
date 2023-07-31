require 'spec_helper'

describe 'Acessa os endpoints' do
  it 'de exames, buscando todos exames' do
    conn = Database.connect
    conn.exec("INSERT INTO patients (cpf, name, email, birthdate, address, city, state) VALUES ('12345678900', 'João', '123@gmail.com', '1990-01-01', 'Rua 1', 'Cidade 1', 'Estado 1')")
    conn.exec("INSERT INTO doctors (crm, crm_state, name, email) VALUES ('B000BJ20J4', 'SP', 'João', '123')")
    conn.exec("INSERT INTO exams (patient_id, doctor_id, token, date) VALUES (1, 1, '1234567890', '1990-01-01')")
    conn.exec("INSERT INTO tests (exam_id, type, limits, result) VALUES (1, 'Tipo 1', 'Limites 1', 'Resultado 1')")

    visit '/api/v1/exams'

    expect(page).to have_content('{"date":"1990-01-01","exam_id":"1","token":"1234567890","cpf":"12345678900"')
    expect(page).to have_content(',"patient_name":"João","patient_birthdate":"1990-01-01","doctor_name":"João"}')
  end

  it 'de exames, mas não há dados cadastrados no banco' do
    visit '/api/v1/exams'
    expect(page).to have_content('[]')
  end

  it 'de exames por ID, buscando todos dados do exame' do
    conn = Database.connect
    conn.exec("INSERT INTO patients (cpf, name, email, birthdate, address, city, state) VALUES ('12345678900', 'João', '123@gmail.com', '1990-01-01', 'Rua 1', 'Cidade 1', 'Estado 1')")
    conn.exec("INSERT INTO doctors (crm, crm_state, name, email) VALUES ('B000BJ20J4', 'SP', 'João', '123')")
    conn.exec("INSERT INTO exams (patient_id, doctor_id, token, date) VALUES (1, 1, '1234567890', '1990-01-01')")
    conn.exec("INSERT INTO tests (exam_id, type, limits, result) VALUES (1, 'Tipo 1', 'Limites 1', 'Resultado 1')")

    conn.exec("INSERT INTO exams (patient_id, doctor_id, token, date) VALUES (1, 1, '123321123', '2020-01-01')")
    conn.exec("INSERT INTO tests (exam_id, type, limits, result) VALUES (2, 'Tipo 2', 'Limites 2', 'Resultado 2')")

    visit '/api/v1/exams/2'

    expect(page).to have_content('{"result_token":"123321123","result_date":"2020-01-01","cpf":"12345678900",')
    expect(page).to have_content('"name":"João","email":"123@gmail.com","birthday":"1990-01-01",')
    expect(page).to have_content('"doctor":{"crm":"B000BJ20J4","crm_state":"SP","name":"João","email":"123"},')
    expect(page).to have_content('"tests":[{"type":"Tipo 2","limits":"Limites 2","result":"Resultado 2"}]}')
  end

  it 'de exames por ID, mas não existe a id' do
    visit '/api/v1/exams/1'
    expect(page).to have_content('{}')
  end

  it 'de exames por Token, buscando todos dados do exame' do
    conn = Database.connect
    conn.exec("INSERT INTO patients (cpf, name, email, birthdate, address, city, state) VALUES ('12345678900', 'João', '123@gmail.com', '1990-01-01', 'Rua 1', 'Cidade 1', 'Estado 1')")
    conn.exec("INSERT INTO doctors (crm, crm_state, name, email) VALUES ('B000BJ20J4', 'SP', 'João', '123')")
    conn.exec("INSERT INTO exams (patient_id, doctor_id, token, date) VALUES (1, 1, '1234567890', '1990-01-01')")
    conn.exec("INSERT INTO tests (exam_id, type, limits, result) VALUES (1, 'Tipo 1', 'Limites 1', 'Resultado 1')")

    conn.exec("INSERT INTO exams (patient_id, doctor_id, token, date) VALUES (1, 1, '123TOKEN', '2020-01-01')")
    conn.exec("INSERT INTO tests (exam_id, type, limits, result) VALUES (2, 'Tipo 2', 'Limites 2', 'Resultado 2')")

    visit '/api/v1/exams/token/123TOKEN'

    expect(page).to have_content('{"result_token":"123TOKEN","result_date":"2020-01-01","cpf":"12345678900",')
    expect(page).to have_content('"name":"João","email":"123@gmail.com","birthday":"1990-01-01",')
    expect(page).to have_content('"doctor":{"crm":"B000BJ20J4","crm_state":"SP","name":"João","email":"123"},')
    expect(page).to have_content('"tests":[{"type":"Tipo 2","limits":"Limites 2","result":"Resultado 2"}]}')
  end

  it 'de exames por Token, mas não existe o token' do
    visit '/api/v1/exams/token/123TOKEN'
    expect(page).to have_content('{}')
  end
end