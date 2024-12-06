# Define the feedback_while_loop function
def feedback_while_loop():
  # Collect feedback from customers using a while loop
    feedback_list = []
    # Use a while loop to collect feedback
    while True:
      # Get feedback from the customer
        feedback = input("Enter customer feedback (or 'stop' to finish): ")
        # Add the feedback to the list
        if feedback.lower() == 'stop':
          # Exit the loop if the user enters 'stop'
            break
            # Add the feedback to the list
        feedback_list.append(feedback)
    # Print the collected feedback
    print("\nCollected Feedback:")
    # Use an enumerate function to get the customer number
    for i, feedback in enumerate(feedback_list, 1):
      # Print the feedback for each customer
        print(f"Customer {i}: {feedback}")

# Run the program
feedback_while_loop()
