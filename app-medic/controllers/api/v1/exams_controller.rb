require './database'
require 'rack'

class ExamsController < Database
  def index
    conn = Database.connect
    
    res = conn.exec(' SELECT exams.date, exams.id AS exam_id, exams.token,
                      patients.cpf, patients.name AS patient_name, patients.birthdate AS patient_birthdate,
                      doctors.name AS doctor_name
                      FROM exams
                      INNER JOIN patients ON exams.patient_id = patients.id
                      INNER JOIN doctors ON exams.doctor_id = doctors.id')

    conn.close

    res.to_a.to_json
  end

  def show(id)
    conn = Database.connect
  
    exam_res = conn.exec_params('SELECT exams.date, exams.token,
                                 patients.cpf, patients.name AS patient_name, patients.email AS patient_email, patients.birthdate AS patient_birthdate,
                                 doctors.crm, doctors.crm_state, doctors.name AS doctor_name, doctors.email as doctor_email
                                 FROM exams
                                 INNER JOIN patients ON exams.patient_id = patients.id
                                 INNER JOIN doctors ON exams.doctor_id = doctors.id
                                 WHERE exams.id = $1', [id])
  
    return {}.to_json if exam_res.ntuples.zero?
    exam_data = exam_res[0]
  
    test_res = conn.exec_params('SELECT type AS test_type, limits AS test_limits, result AS test_result
                                 FROM tests
                                 WHERE exam_id = $1', [id])
  
    tests_data = test_res.map do |test|
      {
        "type": test['test_type'],
        "limits": test['test_limits'],
        "result": test['test_result']
      }
    end
  
    result = {
      "result_token": exam_data['token'],
      "result_date": exam_data['date'],
      "cpf": exam_data['cpf'],
      "name": exam_data['patient_name'],
      "email": exam_data['patient_email'],
      "birthday": exam_data['patient_birthdate'],
      "doctor": {
        "crm": exam_data['crm'],
        "crm_state": exam_data['crm_state'],
        "name": exam_data['doctor_name'],
        "email": exam_data['doctor_email']
      },
      "tests": tests_data
    }
  
    conn.close
    result.to_json
  end

  def show_by_token(token)
    conn = Database.connect
  
    exam_res = conn.exec_params('SELECT exams.id, exams.date, exams.token, 
                                 patients.cpf, patients.name AS patient_name, patients.email AS patient_email, patients.birthdate AS patient_birthdate,
                                 doctors.crm, doctors.crm_state, doctors.name AS doctor_name, doctors.email as doctor_email
                                 FROM exams
                                 INNER JOIN patients ON exams.patient_id = patients.id
                                 INNER JOIN doctors ON exams.doctor_id = doctors.id
                                 WHERE exams.token = $1', [token])
  
    return {}.to_json if exam_res.ntuples.zero?
    exam_data = exam_res[0]
    exam_id = exam_data['id']
  
    test_res = conn.exec_params('SELECT type AS test_type, limits AS test_limits, result AS test_result
                                 FROM tests
                                 WHERE exam_id = $1', [exam_id])
  
    tests_data = test_res.map do |test|
      {
        "type": test['test_type'],
        "limits": test['test_limits'],
        "result": test['test_result']
      }
    end
  
    result = {
      "result_token": exam_data['token'],
      "result_date": exam_data['date'],
      "cpf": exam_data['cpf'],
      "name": exam_data['patient_name'],
      "email": exam_data['patient_email'],
      "birthday": exam_data['patient_birthdate'],
      "doctor": {
        "crm": exam_data['crm'],
        "crm_state": exam_data['crm_state'],
        "name": exam_data['doctor_name'],
        "email": exam_data['doctor_email']
      },
      "tests": tests_data
    }
  
    conn.close
    result.to_json
  end
  
end
