require 'pg'

class Database
  def self.connect
    PG.connect(host: 'db', dbname: 'postgres', user: 'postgres')
  end

  def self.drop
    conn = Database.connect
    conn.exec('DROP TABLE IF EXISTS tests')
    conn.exec('DROP TABLE IF EXISTS exams')
    conn.exec('DROP TABLE IF EXISTS doctors')
    conn.exec('DROP TABLE IF EXISTS patients')
    conn.close
  end

  def self.create
    conn = Database.connect

    conn.exec('CREATE TABLE IF NOT EXISTS patients (
      id serial PRIMARY KEY,
      cpf VARCHAR(14) UNIQUE NOT NULL,
      name VARCHAR(100) NOT NULL,
      email VARCHAR(100) NOT NULL,
      birthdate DATE NOT NULL,
      address VARCHAR(200),
      city VARCHAR(100),
      state VARCHAR(100)
    )')
    
    conn.exec('CREATE TABLE IF NOT EXISTS doctors (
      id serial PRIMARY KEY,
      crm VARCHAR(10) UNIQUE NOT NULL,
      crm_state VARCHAR(2) NOT NULL,
      name VARCHAR(100) NOT NULL,
      email VARCHAR(100) NOT NULL
    )')
    
    conn.exec('CREATE TABLE IF NOT EXISTS exams (
      id serial PRIMARY KEY,
      patient_id integer REFERENCES patients(id),
      doctor_id integer REFERENCES doctors(id),
      token VARCHAR(10) UNIQUE NOT NULL,
      date DATE NOT NULL
    )')
    
    conn.exec('CREATE TABLE IF NOT EXISTS tests (
      id serial PRIMARY KEY,
      exam_id integer REFERENCES exams(id),
      type VARCHAR(100) NOT NULL,
      limits VARCHAR(100),
      result VARCHAR(100)
    )')
    
    conn.close
  end
end