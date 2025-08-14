# Setttings
/* 	
	ENUM? 
	MemberType: Not registered, Non deposit, deposited 
    CallStatus: Pending, Success, Call later, Wrong Number
    StatusCase: Pending, Done, Closed, Transfer ?? 
    CRM: William, Happy, Bita, Tiger
    TLS: Katie
    AccountStatus: Normal, VIP
    *New* LifeCycle: TLS1, TLS2, TLS3, CRM
*/ 

# Data
/*
	Username: VARCHAR
    FullName: VARCHAR
    Tel: VARCHAR
    Membertype: Enum
	Email: VARCHAR
    DOB: DATE
    VIP Level: ? 
    Line: ?
    Day Record: DATE
    RegisterDate: DATE
    Source: ? 
*/

# Telesales 
/* 
	Username: VARCHAR
    FullName: VARCHAR
    Tel: VARCHAR
    MemberType: ENUM 
    CallStatus: ENUM
	CaseStatus: ENUM
    CaseNote: VARCHAR
    LifeCycle: ENUM 
    RegisterDate: DATE
    Line: ?
*/

# CRM
/* 
	Username: VARCHAR
    Fullname: VARCHAR
    Tel: VARCHAR
    Contact: VARCHAR
    Member Type: ENUM	
    CallStatus: ENUM
    CaseStatus: ENUM
    CaseNote: VARCHAR
    AccountStatus: ENUM
    Amount: DECIMAL(13,2)
    CallDate: DATE 
    RegisterDate: DATE
    Line: ?
    CRM1: VARCHAR (ENUM?)
    CRM2: VARCHAR (ENUM?)
	NumOfDays: INT
*/

# To be added:
/* 
	NumOfDeposit: INT
    LastDepositDate : DATE
*/