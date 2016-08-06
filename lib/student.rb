require_relative "../config/environment.rb"
require 'pry'

class Student

 attr_accessor :name, :grade, :id
  

  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY, name TEXT, grade TEXTs)"

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def save
    if self.id == nil
      sql = "INSERT INTO students (name, grade)
       VALUES (?, ?)"

       DB[:conn].execute(sql, self.name, self.grade)

       sql = "SELECT id FROM students ORDER BY id DESC LIMIT 1"
       ident = DB[:conn].execute(sql)

       self.id=ident[0][0]
   else 
    self.update
    end
  end

  def update 
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
    
    sql = "SELECT * FROM students WHERE id = ?"
    DB[:conn].execute(sql, self.id)
  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
  end

  def self.new_from_db(row)
    new_student = Student.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    row = DB[:conn].execute(sql, name)
    
    student = self.new_from_db(row[0])
  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
