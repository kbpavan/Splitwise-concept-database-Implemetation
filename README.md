 ![](Images/1.png)

This database implementation is inspired by the splitwise expenses sharing
android/ios application. We created a working prototype of database that can be
used by an application similar to splitwise.

This project majorly involves 2 steps

1.  DATABASE PLANNING

2.  DATABASE DESIGN

In Database planning step our aim is to decide on our mission statement, objectives
and standards for development.

DATABASE PLANNING
===============================

**MISSION STATEMENT**

Sharebill's mission is to make shared living and travel easier by providing
neutral advice, fair judgement, and simplified expense sharing through Database
management system.

**MISSION OBJECTIVES**

To maintain (INSERT, UPDATE, DELETE) DATA ON USERS

To maintain (INSERT, UPDATE, DELETE) DATA ON TRANSACTIONS

To maintain (INSERT, UPDATE, DELETE) DATA ON GROUPS

To maintain (INSERT, UPDATE, DELETE) DATA ON TRANSACTION_DETAIL

To maintain (INSERT, UPDATE, DELETE) DATA ON GROUP_MEMBERS

To maintain (INSERT, UPDATE, DELETE) DATA ON SETTLEUP_REQUEST

To perform searches on USERS

To perform searches on TRANSACTIONS

To perform searches on GROUPS

To perform searches on TRANSACTION_DETAIL

To perform searches on GROUP_MEMBERS

To perform searches on SETTLEUP_REQUEST

To track the status of settled transactions

To track status of transactions of Group members

To report the monthly transaction of a particular group.

**STANDARDS DEVELOPMENT**

2.  The user should be a sharebills account holder

3.  Transactions such as Group or non-group transaction is allowed

4.  Any transaction can involve one or many users including himself

5.  User (borrower) can send a Settle up request to another user (lender)

6.  User can include the limited users from the group members

7.  User can take note of any number of users in the non-group transaction

8.  Settle up request should be initiated by borrower and settle up should be
    done by lender only.

DATABASE DESIGN
=========================

Database Design involves creating business rules and ERD diagram.

**BUSINESS RULES**

ShareBills is a database where transactions of all shared expenses between users
is stored.

-   ShareBills can get transactions from individual users and users from
    different groups.

-   Each user can be a part of none of the group or several groups.

-   Each group can have two or more users.

-   Every transaction involves two or more users. For example, Walmart expense
    is a transaction of common groceries with the amount of 200 USD that
    involved multiple users made on a particular day.

-   Each user can have zero or many transactions.

-   For each user there is zero settle up request or many settle up requests.

-   Every user is identified by User ID. The first name, last name, middle name,
    email id, and phone number of all users are recorded in the system.

-   A borrower can send a settle up request to lender once he repays the amount
    lent from borrower. Once the lender approves the settle up request, the rows
    in the Transaction detail entity will be updated.

-   Transaction detail entity has information about transaction id, borrower id,
    debt amount, settled up flag, and settle up request id.

-   For every group, group id, group name and group created date is maintained.

-   For every single settle up request is known by Request id. In addition,
    request made by a user, request sent to a user with the request status,
    request received date, request accepted date, and request group id is stored
    in the system.

-   A particular transaction is recognized by transaction id. Transaction owner
    id, Lender id along with the transaction group id, transaction date,
    transaction amount, and a transaction comment are also kept in the database.

**ERD DIAGRAM**

![](https://github.com/kbpavan/Splitwise-concept-database-Implemetation/blob/master/Images/2.jpg)
