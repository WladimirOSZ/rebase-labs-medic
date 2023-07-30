require 'sidekiq'
require 'csv'
require_relative 'database'


class CsvImporter
  include Sidekiq::Worker

  def perform(csv)
    Database.create
    conn = Database.connect
    
    patient = {}
    doctor = {}
    exam = {}
    tests = {}

    patients_result = conn.exec('SELECT id, cpf FROM patients')
    patients_result.each do |row|
      patient[row['cpf']] = row['id'].to_i
    end

    doctors_result = conn.exec('SELECT id, crm FROM doctors')
    doctors_result.each do |row|
      doctor[row['crm']] = row['id'].to_i
    end

    exams_result = conn.exec('SELECT id, token FROM exams')
    exams_result.each do |row|
      exam[row['token']] = row['id'].to_i
    end

    tests_result = conn.exec('SELECT * FROM tests')

    tests_result.each do |test|
      test_key = "#{test['exam_id']}-#{test['type']}-#{test['limits']}-#{test['result']}"
      tests[test_key] = test['id'].to_i
    end

    rows = CSV.parse(csv, headers: true, col_sep: ';')

    res = rows.map do |row|
      exam_token = row[11]
      if exam.include?(exam_token)
        exam_id = exam[exam_token]
        
        test_key = "#{exam_id}-#{row[13]}-#{row[14]}-#{row[15]}"
        unless tests.include?(test_key)
          conn.exec_params('INSERT INTO tests (exam_id, type, limits, result) VALUES ($1, $2, $3, $4)',
                                              [exam_id, row[13], row[14], row[15]])
        end
      else
        doctor_crm = row[7]
        patient_cpf = row[0]

        unless patient.include?(patient_cpf)
          result = conn.exec_params('INSERT INTO patients (cpf, name, email, birthdate, address, city, state) VALUES ($1, $2, $3, $4, $5, $6, $7) 
                                    ON CONFLICT (cpf) DO NOTHING 
                                    RETURNING id',
                                    [row[0], row[1], row[2], row[3], row[4], row[5], row[6]])
          patient[patient_cpf] = result[0]['id'].to_i
        end

        unless doctor.include?(doctor_crm)
          result = conn.exec_params('INSERT INTO doctors (crm, crm_state, name, email) VALUES ($1, $2, $3, $4) 
                                     ON CONFLICT (crm) DO NOTHING 
                                     RETURNING id',
                                     [row[7], row[8], row[9], row[10]])
          doctor[doctor_crm] = result[0]['id'].to_i
        end

        patient_id = patient[patient_cpf]
        doctor_id = doctor[doctor_crm]
        exam_date = Date.parse(row[12])

        result = conn.exec_params('INSERT INTO exams (patient_id, doctor_id, token, date) VALUES ($1, $2, $3, $4) 
                                   ON CONFLICT (token) DO NOTHING 
                                   RETURNING id',
                                   [patient_id, doctor_id, exam_token, exam_date])
        exam[exam_token] = result[0]['id'].to_i
        
        conn.exec_params('INSERT INTO tests (exam_id, type, limits, result) VALUES ($1, $2, $3, $4)',
                                            [exam_id, row[13], row[14], row[15]])
      end
      
    end
    conn.close
    puts 'Importado com sucesso.'
  end
end
