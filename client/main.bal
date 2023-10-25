import ballerina/graphql;
import ballerina/io;

 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================


type serverResponse record {|
    *graphql:GenericResponseWithErrors;
    record {|Response theResponse;|} data;
|};

 
type Response record {
    string result;
};

type User record {
    string firstname;
    string lastname;
    string jobtitle;
    string position;
    string role;
    string kpi;
    string score;
    string grade;
    string objective;
};

type userResponse record {|
  record {|User theUser;|} data;  
|};
graphql:Client graphqlClient = check new ("localhost:9090/Performance_manager");

 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================


public function main() returns error? {
    
    io:println(SignIn());
}

function MainMenu() returns string|error{
    io:println("==MAIN MENU== |");
    io:println("\n\n 1) SignIn");
    io:println("\n 2) SignUp");

    string input =io:readln("select an option__:");

    if input == "1" {
        return SignIn();
    }
    else if input == "2" {
        return Register();
    }
    else {
        return MainMenu();
    }

      
}

 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================

function Login() returns string|error? {

    string user = io:readln("Enter Password");
    string password = "\""+user;
    string document2 = " { authentication(password:"+password+"\") { result } } ";

    map<json> response = check graphqlClient->execute(document2); 
    json|error resultValue = response.data.authentication.result;
    io:println("--<json>");
    io:println(resultValue);
    if resultValue == "user" {
        io:println("Access granted");
    }
    io:println("--String--");
    io:println(response.data.authentication.result);

    return "";

};

 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================


function SignIn() returns string|error {

    string user = io:readln("Enter Username");
    string username = "\""+user;
    string document = " { getPassword(username:"+username+"\") } ";

    map<json> response = check graphqlClient->execute(document); 
    json|error resultValue = response.data.getPassword;

    io:println("--<json>");
    io:println(resultValue);
    
    if resultValue == "password" {
        io:println("Access granted");
        io:println(menuSelect(user));
    } else {
        io:println("Access Denied");
    }
   
    return "";
};

 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================

function menuSelect(string usr) returns string|error {

    string user = usr;
    string username = "\""+user;

    string document = " { getPosition(username:"+username+"\") } ";

    map<json> response = check graphqlClient->execute(document); 
    json|error resultValue = response.data.getPosition;

    if resultValue == "supervisor" {
        return SupervisorMenu(user);

    } 
    else if resultValue == "hod" {
        return hodMenu();
    }
    else if resultValue == "employee" {
        return EmployeeMenu(user);
    }
    else {
        return menuSelect(user);
    }
}
function hodMenu() returns string|error{
    io:println("===========================THIS IS TO DEAL WITH HOD FUNCTIONS===========================");
    io:println("\n\n 1)===========================Create Objectives===========================: ");
    io:println("\n 2)=========================== Delete Objectives===========================: ");
    io:println("\n 3) ===========================iew Total Scores===========================: ");
    io:println("\n 4)===========================Assign Employee: ");
       string input =io:readln("===========================WHICH OPTION WOULD YOU LIKE TO TAKE ?=========================== ");

    if input == "1" {
        return createObj();
    }
    else if input == "2" {
        return " ";
    }
    else if input == "3" {
        return totalScores();
    }
    else if input == "4" {
        return assign();
    }
    else {
        return MainMenu();
    }   
}


 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================


function SupervisorMenu(string user) returns string|error{
    io:println("===========================THIS MENU IS FOR THE FUNCTIONS OF THE SUPERVISOR===========================");
    io:println("\n\n 1)===========================unction Acccept KPI===========================: ");
    io:println("\n   2) =========================== FunctionDelete KPI===========================: ");
    io:println("\n   3) ===========================Function Update KPI===========================: ");
    io:println("\n   4) ===========================unction View Scores===========================: ");
    io:println("\n   5) ===========================Function Grade KPI===========================:  ");

    string input =io:readln("FOLLOW THE OPTION TO CONTINUE BY INSERTING A NUMBER: ");

    if input ==      "1" {
        return ApproveKPI(user);
    }
    else if input == "2" {
        return DeleteKPI(user);
    }
    else if input == "3" {
        return UpdateKPI(user);
    }
    else if input == "4" {
        return EmployeeScores(user);
    }
    else if input == "5" {
        return gradeKPI(user);
    }
    else {
        return MainMenu();
    }   
}

 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================

function EmployeeMenu(string user) returns string|error{
    io:println("========================THIS IS APPLICABLE TO THE EMPLOYEE ONLY ========================");
    io:println("\n\n 1)========================Function Create KPI===========================");
    io:println("\n   2)======================== Function Grade the Supervisor:                ");
    io:println("\n   3)========================Function View your Total Scores:========================");
    
    string input =io:readln("===========SPECIFY ONE OPTION FROM THE LIST- BY PRESSING THE NUMBER YOU WANT=========:  ");

    if input == "1" {
        return CreateKPI(user);
    }
    else if input == "2" {
        return GradeSup(user);
    }
    else if input == "3" {
        return ViewScore(user);
    }
    else {
        return MainMenu();
    }     
}


 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================

function Register() returns string|error{

 string firstName = io:readln("==============FIRSTNAME==============: ");  
 string fname = "\""+firstName;

 string lastName = io:readln("===============LASTNAME===============: "); 

  string position = io:readln("==============POSITION===============: ");
 string psition = "\""+position;
 string lname = "\""+lastName;

 string jobtitle = io:readln("================JOB TITLE==============: ");
 string jtitle = "\""+jobtitle;



 string role = io:readln("|------Enter Role------|=  ");
 string rle = "\""+role;

 string objective = io:readln("Enter Objective");
 string obj = "\""+objective;
string document = " { createUser(firstName:"+fname+"\",lastName:"+lname+"\",jobTitle:"+jtitle+"\",Position:"+psition+"\",Role:"+rle+"\",Objective:"+obj+"\") { firstname } } ";

map<json> response = check graphqlClient->execute(document); 


    return "";
}


 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================

function createObj() returns string|error {

    string id = io:readln("=============press C + enter to exit==============");
    string Id = "\""+id;

    
    string obj = io:readln("|------Enter Objective--------: ");
    string objective = "\""+obj;

    string document = "{ createObjectives(id: "+Id+"\",obj:"+objective+"\")  }";
     
    map<json> response = check graphqlClient->execute(document); 
    json|error resp = response.data.createObjectives;

    io:println(resp);

    string input = io:readln("=============press C + enter to exit==============");

    if(input == "c") {
        return hodMenu();
    }
    return hodMenu();
};

 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================


function totalScores() returns string|error {

    string document = "{ viewTotalScores }";

     map<json> response = check graphqlClient->execute(document); 
    json|error resp = response.data.viewTotalScores;

    io:println(resp);

    string input = io:readln("=============press C + enter to exit==============");

    if(input == "c") {
        return hodMenu();
    }
    return hodMenu();
}

 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================

function assign() returns string|error {


    string id = io:readln("================EMPLOYEE ID: ============");
    string Id = "\""+id;

    
    string supervisor = io:readln("=======SUPERVISOR NAME: ============");
    string super = "\""+supervisor;

    string document = "{ assign(empId: "+Id+"\",super:"+super+"\")  }";
     
    map<json> response = check graphqlClient->execute(document); 
    json|error resp = response.data.assign;

    io:println(resp);

    string input = io:readln("===========PRESS C TO EXIT============= ");

    if(input == "C") {
        return hodMenu();
    }
    return hodMenu();
};

 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================

function EmployeeScores(string sup) returns string|error {

    string supervisor =  sup;
    string super = "\""+supervisor;

    string document = "{ EmployeeScores(super:"+super+"\")  }";
     
    map<json> response = check graphqlClient->execute(document); 
    json|error resp = response.data.EmployeeScores;

    io:println(resp);

      string input = io:readln("=============press C + enter to exit==============");

     if(input == "c") {
        return SupervisorMenu(sup);
    }

    return SupervisorMenu(sup);

};

 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================

function ApproveKPI(string user) returns string|error {

    string empId = io:readln("===============EMPLOYEE ID==========: ");
    string id = "\""+empId;

    string status = io:readln("====================STATUS==================");
    string Status = "\""+status;

    string document = "{ ApproveKPI(empId:"+id+"\",status:"+Status+"\") }";
     
    map<json> response = check graphqlClient->execute(document); 
    json|error resp = response.data.ApproveKPI;

    io:println(resp);

    string input = io:readln("=============press C + enter to exit==============");

    if(input == "c") {
        return SupervisorMenu(user);
    }
    return SupervisorMenu(user);
};

 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================

function UpdateKPI(string user) returns string|error {

    string empId = io:readln("============================EMPLOYEE ID===============================");
    string id = "\""+empId;

    string kpi = io:readln("Enter KPI");
    string KPI = "\""+kpi;

    string document = "{ updateKPI(empId:"+id+"\",KPI:"+KPI+"\") }";
     
    map<json> response = check graphqlClient->execute(document); 
    json|error resp = response.data.ApproveKPI;

    io:println(resp);

     string input = io:readln("=============press C + enter to exit==============");

     if(input == "C") {
        return SupervisorMenu(user);
    }


    return SupervisorMenu(user);
};


 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================

function gradeKPI(string user) returns string|error {

    string empId = io:readln("=====================================EMPLOYEE ID=====================================");
    string id = "\""+empId;

    string kpi = io:readln("GRADE THE KPI");
    string KPI = "\""+kpi;

    string document = "{ gradeKPI(empId:"+id+"\",grade:"+KPI+"\") }";
     
    map<json> response = check graphqlClient->execute(document); 
    json|error resp = response.data.gradeKPI;

    io:println(resp);

     string input = io:readln("=============press c + enter to exit==============");

     if(input == "C") {
        return SupervisorMenu(user);
    }
    return SupervisorMenu(user);

};

function GradeSup(string user) returns string|error {

    string usr = io:readln("============SUPERVISOR NAME: ============");
    string username = "\""+usr;

    string kpi = io:readln("put in the grade");
    string KPI = "\""+kpi;

    string document = "{ gradeSup(username:"+username+"\",KPI:"+KPI+"\") }";
     
    map<json> response = check graphqlClient->execute(document); 
    json|error resp = response.data.gradeSup;

    io:println(resp);

     string input = io:readln("Enter d to exit...");

     if(input == "d") {
        return EmployeeMenu(user);
    }
    return EmployeeMenu(user);

};

 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================

function DeleteKPI(string user) returns string|error {

    string empId = io:readln("================EMPLOYEE ID=================:  ");
    string id = "\""+empId;

     

    string document = "{ deleteKPI(empId:"+id+"\") }";
     
    map<json> response = check graphqlClient->execute(document); 
    json|error resp = response.data.deleteKPI;

    io:println(resp);

     string input = io:readln("Enter d to exit...");

     if(input == "d") {
        return SupervisorMenu(user);
    }

    return SupervisorMenu(user);
};
function CreateKPI(string user) returns string|error {

    string usr = user;
    string username = "\""+usr;

    string kpi = io:readln("Enter KPI");
    string KPI = "\""+kpi;

    string document = "{ createKPI(username:"+username+"\",KPI:"+KPI+"\") }";
     
    map<json> response = check graphqlClient->execute(document); 
    json|error resp = response.data.createKPI;

    io:println(resp);

     string input = io:readln("=============press c + enter to exit==============");

     if(input == "c") {
        return EmployeeMenu(user);
    }
    return EmployeeMenu(user);

};


 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================

 
function ViewScore(string user) returns string|error {

    string usr =  user;
    string username = "\""+usr;

    string document = "{ viewKPI(username:"+username+"\")  }";
     
    map<json> response = check graphqlClient->execute(document); 
    json|error resp = response.data.viewKPI;

    io:println(resp);
     string input = io:readln("=============press c + enter to exit==============");
     if(input == "c") {
        return EmployeeMenu(user);
    }


    return EmployeeMenu(user);

}


 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================


 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
 // =====================================WELCOME TO OUR DSA GROUP PROJECT ======================================================================
