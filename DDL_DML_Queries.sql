 -- Creating Tables

    CREATE TABLE Users (
    User_ID INT not null auto_increment,
    Fname VARCHAR(256),
    Lname VARCHAR(256),
    Mname VARCHAR(256),
    EmailID VARCHAR(256),
    phone VARCHAR(256),
    PRIMARY KEY (User_ID)
);

    CREATE TABLE User_Group (
    Group_ID INT not null auto_increment,
    Group_Name VARCHAR(256),
	CreatedDate DateTime,
    PRIMARY KEY (Group_ID)
);

    CREATE TABLE GroupMember (
    Group_ID INT,
    User_ID INT,
    AddedOn DATETIME,
    FOREIGN KEY (Group_ID)
        REFERENCES User_Group (Group_ID),
    FOREIGN KEY (User_ID)
        REFERENCES Users (User_ID),
    PRIMARY KEY (Group_ID , User_ID)
);

    CREATE TABLE Transactions (
    Trans_ID INT not null auto_increment,
    trans_Owner_ID INT,
    Lender_ID INT,
    Trans_Group_ID INT,
    Trans_Amount INT,
    Trans_Date DATETIME,
    Trans_Comment VARCHAR(256),
    FOREIGN KEY (trans_Owner_ID)
        REFERENCES Users (User_ID),
    FOREIGN KEY (Lender_ID)
        REFERENCES Users (User_ID),
    FOREIGN KEY (trans_Group_ID)
        REFERENCES User_Group (Group_ID),
    PRIMARY KEY (Trans_ID)
);

    CREATE TABLE SettleUP_Request (
    Req_ID INT not null auto_increment,
    From_User_ID INT,
    To_User_ID INT,
    Req_Status BOOLEAN,
    Req_RecievedDate DATETIME,
    Req_AcceptedDate DATETIME,
    Req_Group_ID INT,
    FOREIGN KEY (From_User_ID)
        REFERENCES Users (User_ID),
    FOREIGN KEY (To_User_ID)
        REFERENCES Users (User_ID),
    FOREIGN KEY (Req_Group_ID)
        REFERENCES User_Group (Group_ID),
    PRIMARY KEY (Req_ID)
);

CREATE TABLE Transaction_Details (
    Trans_ID INT,
    Borrower_ID INT,
    Debt_Amount INT,
    SettledUp_Flag BOOLEAN,
    setl_Req_ID INT,
    FOREIGN KEY (Trans_ID)
        REFERENCES Transactions (Trans_ID),
    FOREIGN KEY (Borrower_ID)
        REFERENCES Users (User_ID),
	foreign key (setl_Req_ID)
		references settleup_request (Req_ID),
    PRIMARY KEY (Trans_ID , Borrower_ID)
);

-- Inserting values into the table


INSERT INTO USERS 
( FNAME,LNAME,MNAME,EMAILID,PHONE)
VALUES('JAY','HARKER','NULL','jay@gmail.com','(405)780-2323'),
('CARL','LAYTON','NULL','carl@gmail.com','(405)780-2343'),
('MARC','LEVIN','NULL','marc@gmail.com','(405)780-2353'),
('AMY','DOMINGO','NULL','amy@gmail.com','(405)780-2363'),
('BOBBY','BEST','NULL','bobby@gmail.com','(405)780-2312');

INSERT INTO USER_GROUP
(GROUP_NAME,CREATEDDATE)
VALUES('APARTMENT EXPENSES','2018/12/1'),
('TRIP EXPENSES','2018/12/1');

INSERT INTO GROUPMEMBER
(GROUP_ID,USER_ID,ADDEDON)
VALUES(1,1,'2018/12/1'),
(1,2,'2018/12/1'),
(1,3,'2018/12/1'),
(1,4,'2018/12/1'),
(1,5,'2018/12/1'),
(2,2,'2018/12/1'),
(2,3,'2018/12/1'),
(2,4,'2018/12/1');

INSERT INTO TRANSACTIONS
(TRANS_OWNER_ID,LENDER_ID,TRANS_GROUP_ID, TRANS_AMOUNT,TRANS_DATE,TRANS_COMMENT)

VALUES(1,2,1,100,'2018/12/1','RENT FOR DECEMBER'),
(4,4,2,150,'2018/11/20','TRIP TO DALLAS'),
(2,2,NULL,60,'2018/12/1','RESTAURANT BILL'),
(3,5,NULL,75,'2018/11/20','MOVIE EXPENSES'),
(3,5,1,200,'2018/12/2','Wifi Bill'),
(2,2,2,300,'2018/12/3','Trip to OKC') ;


INSERT INTO TRANSACTION_DETAILS
(TRANS_ID,BORROWER_ID,DEBT_AMOUNT,SETTLEDUP_FLAG,SETL_REQ_ID)
VALUES (1,1,20,0,NULL),
(1,3,20,0,NULL),
(1,4,20,0,NULL),
(1,5,20,0,NULL),
(2,2,50,0,NULL),
(2,3,50,0,NULL),
(3,4,20,0,NULL),
(3,5,20,0,NULL),

(5,1,40,0,NULL),
(5,2,40,0,NULL),
(5,3,40,0,NULL),
(5,4,40,0,NULL),
(6,3,100,0,NULL),
(6,4,100,0,NULL);



INSERT INTO SETTLEUP_REQUEST
(FROM_USER_ID,TO_USER_ID,REQ_STATUS,REQ_RECIEVEDDATE,REQ_ACCEPTEDDATE,REQ_GROUP_ID)
VALUES(1,2,0,'2018/12/1',NULL,1),
(3,4,0,'2018/12/1',NULL,2),
(3,5,0,'2018/12/1',NULL,NULL),
(5,2,0,'2018/12/1',NULL,NULL);


-- Stored Procedure 


CREATE PROCEDURE `Insert_Transaction_Details` (IN INPUT TEXT, 
IN delimiter VARCHAR(10), IN debt_amount Int, in trans_id int)
BEGIN
DECLARE cur_position INT DEFAULT 1 ; 
DECLARE remainder TEXT; 
DECLARE cur_string VARCHAR(1000); 
DECLARE delimiter_length TINYINT UNSIGNED; 

SET remainder = input; 
SET delimiter_length = CHAR_LENGTH(delimiter); 

WHILE CHAR_LENGTH(remainder) > 0 AND cur_position > 0 DO 
SET cur_position = INSTR(remainder, delimiter); 
IF cur_position = 0 THEN 
SET cur_string = remainder; 
ELSE 
SET cur_string = LEFT(remainder, cur_position - 1); 
END IF; 
IF TRIM(cur_string) != '' THEN 
INSERT INTO transaction_details (Trans_ID, Borrower_ID, Debt_Amount,SettledUp_Flag) VALUES (trans_ID,cast(cur_string as unsigned), debt_amount,0); 
commit; 
END IF; 
SET remainder = SUBSTRING(remainder, cur_position + delimiter_length); 
END WHILE; 

END


-- Triggers


/*AFTER INSERT SETTLEUP_REQUEST*/

CREATE DEFINER=`root`@`localhost` TRIGGER `settleup_request_AFTER_INSERT` AFTER INSERT ON `settleup_request` FOR EACH ROW BEGIN
if (NEW.Req_Group_ID is not null) then
UPDATE Transaction_Details 
SET 
    setl_Req_ID = NEW.Req_ID
WHERE
    (borrower_id = NEW.FROM_USER_ID OR borrower_id = NEW.TO_USER_ID) and setl_Req_ID IS NULL AND 
    Trans_ID IN (SELECT 
            td.trans_ID
        FROM
            (select * from transaction_details) td join transactions t on t.trans_id = td.trans_id 
		where t.trans_group_id = NEW.Req_Group_ID and (t.lender_id = NEW.From_User_ID or t.lender_id = NEW.To_User_ID ) 
			AND ( td.borrower_id = NEW.To_User_ID or td.borrower_id = NEW.From_User_ID));
else

UPDATE Transaction_Details 
SET 
    setl_Req_ID = NEW.Req_ID
WHERE
	(borrower_id = NEW.FROM_USER_ID OR borrower_id = NEW.TO_USER_ID) and setl_Req_ID IS NULL AND
    Trans_ID IN (SELECT 
            td.trans_ID
        FROM
            (select * from transaction_details) td join transactions t on t.trans_id = td.trans_id 
		where (t.lender_id = NEW.From_User_ID or t.lender_id = NEW.To_User_ID ) 
			AND ( td.borrower_id = NEW.To_User_ID or td.borrower_id = NEW.From_User_ID));

End if;
END

-- AFTER UPDATE SETTLEUP REQUEST  

CREATE DEFINER=`root`@`localhost` TRIGGER `settleup_request_AFTER_UPDATE` AFTER UPDATE ON `settleup_request` FOR EACH ROW BEGIN
IF (OLD.Req_Status =0 and NEW.Req_Status=1) THEN
		Update Transaction_Details set Settledup_Flag = 1 where Setl_Req_ID = OLD.Req_ID;
END IF;
END