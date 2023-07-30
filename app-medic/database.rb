require 'pg'

class Database
  def self.connect
    PG.connect(host: 'db', dbname: 'postgres', user: 'postgres')
  end

  def self.create
    # Wladimir, volta aqui
    #	password VARCHAR ( 50 ) NOT NULL,
    conn = Database.connect
    conn.exec('DROP TABLE IF EXISTS tests')
    conn.exec('DROP TABLE IF EXISTS exams')
    conn.exec('DROP TABLE IF EXISTS doctors')
    conn.exec('DROP TABLE IF EXISTS patients')

    conn.exec('CREATE TABLE patients (
      id serial PRIMARY KEY,
      cpf VARCHAR,
      name VARCHAR,
      email VARCHAR,
      birthdate DATE,
      address VARCHAR,
      city VARCHAR,
      state VARCHAR
    )')

    conn.exec('CREATE TABLE doctors (
      id serial PRIMARY KEY,
      crm VARCHAR,
      crm_state VARCHAR,
      name VARCHAR,
      email VARCHAR
    )')

    conn.exec('CREATE TABLE exams (
      id serial PRIMARY KEY,
      patient_id integer REFERENCES patients(id),
      doctor_id integer REFERENCES doctors(id),
      token VARCHAR,
      date DATE
    )')

    conn.exec('CREATE TABLE tests (
      id serial PRIMARY KEY,
      exam_id integer REFERENCES exams(id),
      type VARCHAR,
      limits VARCHAR,
      result VARCHAR
    )')
    
    conn.close
  end
end