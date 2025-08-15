# Settings
/* 	
	ENUM? 
	MemberType: Not registered, Non deposit, deposited -- to be
    CallStatus: Pending, Success, Call later, Wrong Number - verify at contacts level? -- to be
    StatusCase: Pending, Done, Closed, Transfer -- done 
    CRM: William, Happy, Bita, Tiger -- Done
    TLS: Katie -- Done 
    AccountStatus: Normal, VIP1, VIP2, VIP3, SUPERVIP - to be
    *New* LifeCycle: TLS1, TLS2, TLS3, CRM - to be
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
    Line: ? VARCHAR?
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
    CaseNote: TEXT
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
    CaseNote: TEXT
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
Notes? 
Transaction table
	NumOfDeposit: INT
    AmountDeposit?
Have a table for contact
Contact_type
	type_id Tel1 Tel2 Tel3 Tele EM ZL VB FB WA WC DC 
    contact_type_name Telephone 1,2,3 Telegram, Email Zalo Viber Facebook Whatsapp WeChat Discord
Customer_contact_info
	cust_id
    Contact_info
    contact_type_id
Usernames
	cust_id
	username
    register_date
    vip_level
    platform_id
Platform
	platform_id
	platform_name
Event table 
	NumOfDeposit: INT
    LastDepositDate : DATE 01/01/2100  
    Notes
Many usernames in each platforms 
*/

/* 
	last_dp_date 
    life_cycle 
*/