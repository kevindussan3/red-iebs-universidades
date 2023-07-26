package main

import (
  "encoding/json"
  "fmt"
  "log"

  "github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// SmartContract provides functions for managing an Student
   type SmartContract struct {
      contractapi.Contract
    }

// Student describes basic details of what makes up a simple student
   type Student struct {
      ID            string `json:"ID"`
      Name          string `json:"name"`
      Surname       string `json:"surname"`
      Age           int    `json:"age"`
      CourseYear    int    `json:"courseYear"`
      CourseName    string `json:"courseName"`
      universityID  string `json:"UniversityID"`
    }

// InitLedger adds a base set of students to the ledger
   func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
    students := []Student{
      {ID: "1", Name: "Kevin", Surname: "Dussan", Age: 24, CourseYear: 1, CourseName: "Master Blockchain", universityID: "IEBS"},
    }

    for _, student := range students {
      studentJSON, err := json.Marshal(student)
      if err != nil {
        return err
      }

      err = ctx.GetStub().PutState(student.ID, studentJSON)
      if err != nil {
        return fmt.Errorf("failed to put to world state. %v", err)
      }
    }

    return nil
  }

// StudentExists returns true when student with given ID exists in world state
  func (s *SmartContract) StudentExists(ctx contractapi.TransactionContextInterface, id string) (bool, error) {
    studentJSON, err := ctx.GetStub().GetState(id)
    if err != nil {
      return false, fmt.Errorf("failed to read from world state: %v", err)
    }

    return studentJSON != nil, nil
  }

// CreateStudent issues a new student to the world state with given details.
   func (s *SmartContract) CreateStudent(ctx contractapi.TransactionContextInterface, id string, name string, surname string, age int, courseyear int, coursename string, universityid string) error {
    exists, err := s.StudentExists(ctx, id)
    if err != nil {
      return err
    }
    if exists {
      return fmt.Errorf("the student %s already exists", id)
    }

    student := Student{
      ID:            id,
      Name:          name,
      Surname:       surname,
      Age:           age,
      CourseYear:    courseyear,
      CourseName:    coursename,
      universityID:  universityid,
    }
    studentJSON, err := json.Marshal(student)
    if err != nil {
      return err
    }

    return ctx.GetStub().PutState(id, studentJSON)
  }


// GetAllStudents returns all students found in world state
   func (s *SmartContract) GetAllStudents(ctx contractapi.TransactionContextInterface) ([]*Student, error) {
// range query with empty string for startKey and endKey does an
// open-ended query of all students in the chaincode namespace.
    resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
    if err != nil {
      return nil, err
    }
    defer resultsIterator.Close()

    var students []*Student
    for resultsIterator.HasNext() {
      queryResponse, err := resultsIterator.Next()
      if err != nil {
        return nil, err
      }

      var student Student
      err = json.Unmarshal(queryResponse.Value, &student)
      if err != nil {
        return nil, err
      }
      students = append(students, &student)
    }

    return students, nil
  }

  func main() {
    studentChaincode, err := contractapi.NewChaincode(&SmartContract{})
    if err != nil {
      log.Panicf("Error creating student-transfer-basic chaincode: %v", err)
    }

    if err := studentChaincode.Start(); err != nil {
      log.Panicf("Error starting student-transfer-basic chaincode: %v", err)
    }
  }

