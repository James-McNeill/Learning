# Class properties
'''
There are two parts to defining a property:

first, define an "internal" attribute that will contain the data;
then, define a @property-decorated method whose name is the property name, and that returns the internal attribute storing the data.
If you'd also like to define a custom setter method, there's an additional step:

define another method whose name is exactly the property name (again), and decorate it with @prop_name.setter where prop_name is the 
name of the property. The method should take two arguments -- self (as always), and the value that's being assigned to the property.
In this exercise, you'll create a balance property for a Customer class - a better, more controlled version of the balance attribute 
that you worked with before.
'''
class Customer:
    def __init__(self, name, new_bal):
        self.name = name
        if new_bal < 0:
           raise ValueError("Invalid balance!")
        self._balance = new_bal  

    # Add a decorated balance() method returning _balance        
    @property
    def balance(self):
        return self._balance

    # Add a setter balance() method
    @balance.setter
    def balance(self, new_bal):
        # Validate the parameter value
        if new_bal < 0:
           raise ValueError("Invalid balance!")
        self._balance = new_bal
        print("Setter method called")

# Create a Customer        
cust = Customer("Belinda Lutz", 2000)

# Assign 3000 to the balance property
cust.balance = 3000

# Print the balance property
print(cust.balance)
