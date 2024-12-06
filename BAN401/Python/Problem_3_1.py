# Define the feedback_for_loop function
def feedback_for_loop():
    # Collect feedback from customers using a for loop
    num_customers = int(input("How many customers do you want to collect feedback from? "))
    # Initialize an empty list to store the feedback
    feedback_list = []

    # Use a for loop to collect feedback
    for i in range(num_customers):
        # Get feedback from the customer
        feedback = input(f"Enter feedback for customer {i+1}: ")
        # Add the feedback to the list
        feedback_list.append(feedback)

    # Print the collected feedback
    print("\nCollected Feedback:")
    # Use an enumerate function to get the customer number
    for i, feedback in enumerate(feedback_list, 1):
      # Print the feedback for each customer
        print(f"Customer {i}: {feedback}")

# Run the program
feedback_for_loop()
