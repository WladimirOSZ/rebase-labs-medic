require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require_relative 'database'
require_relative './controllers/api/v1/exams_controller'


get '/genres' do
  File.open('genres.html')
end

get '/tests' do
  conn = Database.connect

  res = conn.exec('SELECT patients.cpf AS "cpf", patients.name AS "nome paciente", patients.email AS "email paciente", patients.birthdate AS "data nascimento paciente",
                    patients.address AS "endereço/rua paciente", patients.city AS "cidade paciente", patients.state AS "estado paciente",
                    doctors.crm AS "crm médico", doctors.crm_state AS "crm médico estado", doctors.name AS "nome médico", doctors.email AS "email médico",
                    exams.token AS "token resultado exame", exams.date AS "data exame",
                    tests.type AS "tipo exame", tests.limits AS "limites tipo exame", tests.result AS "resultado tipo exame"
                    FROM tests
                    INNER JOIN exams ON tests.exam_id = exams.id
                    INNER JOIN patients ON exams.patient_id = patients.id
                    INNER JOIN doctors ON exams.doctor_id = doctors.id')


  conn.close
  res.to_a.to_json
end



get '/import' do
  require './import_from_csv.rb'
end

get '/exams' do
  require '..rb'
end

get '/api/v1/exams' do
  response.headers['Access-Control-Allow-Origin'] = '*'
  response.headers['Access-Control-Allow-Headers'] = 'Content-Type'
  controller = ExamsController.new
  controller.index
end

get '/api/v1/exams/:id' do
  response.headers['Access-Control-Allow-Origin'] = '*'
  response.headers['Access-Control-Allow-Headers'] = 'Content-Type'
  controller = ExamsController.new
  controller.show(params[:id])
end

get '/api/v1/exams/token/:token' do
  response.headers['Access-Control-Allow-Origin'] = '*'
  response.headers['Access-Control-Allow-Headers'] = 'Content-Type'
  controller = ExamsController.new
  controller.show_by_token(params[:token])
end


Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)