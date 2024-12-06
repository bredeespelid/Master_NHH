print("Loan Approval")

#Validate all input data:
age = int(input("What is your age? "))
income = input("What is your income? ")
income = int(income.replace(",",""))
credit_score = int(input("What is your credit score? "))
debt = input("What is your current amount of existing debt? ")
debt = int(debt.replace(",", ""))
employment_status = input("What is your employment status? (employed/unemployed) ").lower()
loan = input("What loan amount are you requesting? ")
loan = int(loan.replace(",",  ""))
term = int(input("Over how many years would you like to repay the loan?  "))

# Check criteria for loan approval
if 18 <= age <= 70:
    if income > 65000:
        if credit_score > 700:
            debt_ratio = (debt / income) * 100
            if debt_ratio < 40:
                if employment_status == "employed":
                    half_income = income / 2
                    if loan < half_income:
                        if 1 <= term <= 30:
                            print("\n")
                            print(f"You meet all the criteria for a loan, and your request for ${loan} for a term of {term} years has been approved")
                            # If-statement for which interest rate
                            if (700 <= credit_score <= 750) and (term <= 15):
                                print("Your interest rate is 5%")
                            elif (700 <= credit_score <= 750) and (term > 15):
                                print("Your interest rate is 6%")
                            elif (751 <= credit_score <= 800) and (term <= 15):
                                print("Your interest rate is 4%")
                            elif (751 <= credit_score <= 800) and (term > 15):
                                print("Your interest rate is 5%")
                            elif (credit_score > 800) and (term <= 15):
                                print("Your interest rate is 3%")
                            elif (credit_score > 800) and (term > 15):
                                print("Your interest rate is 4%")
                        else:
                            print("Your requested loan term is not within the acceptable range for approval.")
                    else:
                        print("Your requested loan amount is too high relative to your income, making you ineligible to request a loan.")
                else:
                    print("You must be currently employed to request a loan.")
            else:
                print("Your debt-to-income ratio is too high, and you do not qualify to request a loan.")
        else:
            print("You do not meet the credit score requirement to request a loan. ")
    else:
        print("You do not meet the income requirements to request a loan")
else:
    print("You do not meet the age requirements to request a loan")


