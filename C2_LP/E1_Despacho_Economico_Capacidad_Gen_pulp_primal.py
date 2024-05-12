#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat May 11 22:46:10 2024

@author: pm.deoliveiradejes
"""
import pulp as lp

# Create a linear programming problem
model = lp.LpProblem(name="LP_Problem", sense=lp.LpMinimize)

# Define decision variables
x1 = lp.LpVariable(name="x1", lowBound=None)  # x1 >= 0
x2 = lp.LpVariable(name="x2", lowBound=None)  # x2 >= 0


# Add constraints
model += (x1 + x2 == 600, "constraint1")
model += (x1      <= 400, "constraint2")
model += (     x2 <= 300, "constraint3")

# Define the objective function
model += 20 * x1 + 25 * x2, "objective"

# Solve the LP problem
model.solve()

# Print the results
print(f"Optimal value: {lp.value(model.objective)}")
print(f"Optimal solution for x1: {lp.value(x1)}")
print(f"Optimal solution for x2: {lp.value(x2)}")

 