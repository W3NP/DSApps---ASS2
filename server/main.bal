// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

// Import necessary modules
import ballerina/graphql;
import ballerina/io;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

// Define a record type for server response
type serverResponse record {|
    record {|Response theResponse;|} data;
|};

// Define a record type for generic responses
type Response record {
    string result;
};

// Define a record type for password
type thePassword record {
    string password;
};

// Define a record type for user response
type userResponse record {|
    record {|User theUser;|} data;
|};

// Define a record type for objectives
type Objectives record {
    string ObjId;
    string objective;
};

// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

// Define a record type for user details
type User record {
    string firstname;
    string lastname;
    string password;
    string kpi;
    string score;
    string grade;
    string objective;
    string supervisor;
    string jobtitle;
    string position;
    string role;
};

// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

// Define GraphQL service endpoint and initialize MySQL database client
service /Performance_manager on new graphql:Listener(9090) {
    private final mysql:Client db;

    function init() returns error? {
        // Initialize MySQL database client with connection details
        self.db = check new ("localhost", "root", "password", "Department", 3306);
    }

    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

    // Define a resource function for greeting
    resource function get greeting() returns string {
        return "Hello, World";
    }

    // Define a resource function for creating a new user
    resource function get createUser(
            string firstName,
            string lastName,
            string Password,
            string jobTitle,
            string Position,
            string Role,
            string Objective
    ) returns User {

        // Create a user response with provided details
        userResponse resp = {
            data: {
                theUser: {
                    firstname: firstName,
                    lastname: lastName,
                    password: Password,
                    jobtitle: jobTitle,
                    position: Position,
                    role: Role,
                    kpi: "",
                    score: "",
                    grade: "",
                    objective: Objective,
                    supervisor: ""
                }
            }
        };

        // Print user details
        io:println(resp.data.theUser);

        // Return the created user
        return resp.data.theUser;
    }

    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

    // Define a resource function for assigning a supervisor to an employee
    resource function get assign(string empId, string super) returns string|error {

        // Define a SQL parameterized query for updating supervisor
        sql:ParameterizedQuery query = `UPDATE Employees
                                              SET Supervisor = ${super}
                                              WHERE UserId = ${empId};`;

        // Execute the SQL query
        sql:ExecutionResult result = check self.db->execute(query);

        // Return the result of the query
        return result.toString();
    }

    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

    // Define a resource function for retrieving employee scores under a specific supervisor
    resource function get EmployeeScores(string super) returns string|error {

        // Query employees based on supervisor
        stream<User, sql:Error?> users = self.db->query(`SELECT * FROM Employees 
                                                          WHERE Supervisor =${super}`);

        // Construct and return the response with employee details
        return from User usr in users
            select "\n|Name: " + usr.firstname + " " + usr.lastname + "| Total Score: " + usr.score + "| KPI |" + usr.kpi;
    }

    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

    // Define a resource function for user authentication
    resource function get authentication(string password) returns Response {

        // Define a server response with provided password
        serverResponse resp = {
            data: {theResponse: {result: password}}
        };

        // Print server response
        io:println("==========[SERVER]===========");
        io:println(resp.data.theResponse);

        // Check password and return appropriate response
        if (password == "user") {
            return resp.data.theResponse;
        }

        // Return access denied if password doesn't match
        return {result: "Access Denied"};
    }

    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

    // Define a resource function for creating objectives
    resource function get createObjectives(string id, string obj) returns string|error {

        // Execute SQL query to insert objectives
        sql:ExecutionResult result = check self.db->execute(`INSERT INTO Objectives
                                                             VALUES (${id},${obj});`);

        // Return the created objective
        return obj;
    }

    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

    // Define a resource function for viewing total scores of all employees
    resource function get viewTotalScores() returns string|error {

        // Query all employees
        stream<User, sql:Error?> users = self.db->query(`SELECT * FROM Employees`);
        
        // Construct and return the response with employee details and total scores
        return from User usr in users
            select "\n|Name: " + usr.firstname + " " + usr.lastname + "| Total Score: " + usr.score;
    }

    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

    // Define a resource function for deleting KPI of an employee
    resource function get deleteKPI(string empId) returns string|error {

        // Define a SQL parameterized query for updating KPI to 0
        sql:ParameterizedQuery query = `UPDATE Employees
                                              SET KPI = "0"
                                              WHERE UserId = ${empId};`;

        // Execute the SQL query
        sql:ExecutionResult result = check self.db->execute(query);

        // Return the result of the query
        return result.toString();
    }

    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

    // Define a resource function for approving KPI of an employee
    resource function get ApproveKPI(string empId, string status) returns string|error {

        // Define a SQL parameterized query for updating KPI status
        sql:ParameterizedQuery query = `UPDATE Employees
                                              SET KPIStatus = ${status}
                                              WHERE UserId = ${empId};`;

        // Execute the SQL query
        sql:ExecutionResult result = check self.db->execute(query);

        // Return the result of the query
        return result.toString();
    }

    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

    // Define a resource function for updating KPI of an employee
    resource function get updateKPI(string empId, string KPI) returns string|error {

        // Define a SQL parameterized query for updating KPI value
        sql:ParameterizedQuery query = `UPDATE Employees
                                              SET KPI = ${KPI}
                                              WHERE UserId = ${empId};`;

        // Execute the SQL query
        sql:ExecutionResult result = check self.db->execute(query);

        // Return the result of the query
        return result.toString();
    }

    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

    // Define a resource function for grading KPI of an employee
    resource function get gradeKPI(string empId, string grade) returns string|error {

        // Define a SQL parameterized query for updating KPI grade
        sql:ParameterizedQuery query = `UPDATE Employees
                                              SET Grade = ${grade}
                                              WHERE UserId = ${empId};`;

        // Execute the SQL query
        sql:ExecutionResult result = check self.db->execute(query);

        // Return the result of the query
        return result.toString();
    }

    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

    // Define a resource function for creating KPI for an employee
    resource function get createKPI(string username, string KPI) returns string|error {

        // Define a SQL parameterized query for updating KPI value based on username
        sql:ParameterizedQuery query = `UPDATE Employees
                                              SET KPI = ${KPI}
                                              WHERE LastName = ${username};`;

        // Execute the SQL query
        sql:ExecutionResult result = check self.db->execute(query);

        // Return the result of the query
        return result.toString();
    }

    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

    // Define a resource function for viewing KPI of an employee
    resource function get viewKPI(string username) returns string|error {

        // Query employee based on username
        stream<User, sql:Error?> users = self.db->query(`SELECT * FROM Employees 
                                                          WHERE LastName = ${username}`);
        
        // Construct and return the response with employee details and KPI value
        return from User usr in users
            select "\n|Name: " + usr.firstname + " " + usr.lastname + "| KPI : " + usr.kpi;
    }

    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

    // Define a resource function for grading employees under a specific supervisor
    resource function get gradeSup(string sup, string grade) returns string|error {

        // Define a SQL parameterized query for updating employee grade based on supervisor
        sql:ParameterizedQuery query = `UPDATE Employees
                                              SET Grade = ${grade}
                                              WHERE Supervisor = ${sup};`;

        // Execute the SQL query
        sql:ExecutionResult result = check self.db->execute(query);

        // Return the result of the query
        return result.toString();
    }

    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

    // Define a resource function for getting password of an employee
    resource function get getPassword(string username) returns string|error {
        
        // Query password based on username
        stream<User, sql:Error?> users = self.db->query(`SELECT * FROM Employees
                                                             WHERE LastName = ${username};`);

        // Return the password of the user
        return from User us in users
            select us.password;
    }

    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
    // =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

    // Define a resource function for getting position of an employee
    resource function get getPosition(string username) returns string|error {

        // Query position based on username
        stream<User, sql:Error?> users = self.db->query(`SELECT * FROM Employees
                                                             WHERE LastName = ${username};`);

        // Return the position of the user
        return from User us in users
            select us.position;
    }
}
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================

// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
// =====================================WELCOME TO OUR DSA GROUP PROJECT =====================================
