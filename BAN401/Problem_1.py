#function for password checker
def password_checker():
    # Variabel for the correct password
    correct_password = "friend"
    # Variabel for the number of attempts
    count = 5

    # Loop for the number of attempts
    while count > 0:

        # Input for the password
        password = input("Enter your password to access the client database: ")
        # Decrement the number of attempts
        count -= 1

        # Check if the password is correct
        if password == correct_password:
            # If the password is correct, print a message and exit the loop
            print("Access granted. Welcome, friend!")
            return

        # Partial match calculation
        matches = sum(1 for i in range(min(len(password), len(correct_password))) if password[i] == correct_password[i])
        # Total length calculation
        total_length = len(correct_password)
        
        # Print the result
        if matches > total_length / 2:
            # Calculate the percentage of partial matches
            partial_match_percentage = (matches / total_length) * 100
            # Print the result
            print(f"Partial match: {partial_match_percentage:.1f}% Attempts remaining: {count}")
        else:
            # Print the result
            print(f"Incorrect password. Attempts remaining: {count}")

    # If the number of attempts is exceeded, print an error message
    print("Incorrect password supplied 5 (five) times. Access denied.")

# Run the password checker
password_checker()
