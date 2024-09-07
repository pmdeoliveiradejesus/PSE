#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Sep  6 19:32:34 2024

@author: pm.deoliveiradejes
"""

from scipy.optimize import minimize
import numpy as np

# Given constants
XL = 0.1
PD0 = 0.3
QD0 = 0.15

# Define the objective function to minimize |1 - V1|
def objective(x):
    V1, t1, Qc = x
    return abs(1 - V1)

# Define the equality constraints
def constraint1(x):
    V1, t1, Qc = x
    return V1 * np.sin(t1) / XL + PD0 * (0.25 + 0.25 * V1 + 0.25 * V1**2 + 0.25 * V1**3)

def constraint2(x):
    V1, t1, Qc = x
    return Qc - QD0 - (V1**2 - V1 * np.cos(t1)) / XL

# Initial guesses for V1, t1, and Qc
initial_guess = [1.0, 0.0, 0.2]

# Set up the constraints in a format suitable for 'minimize'
constraints = [{'type': 'eq', 'fun': constraint1},
               {'type': 'eq', 'fun': constraint2}]

# Solve the problem
solution = minimize(objective, initial_guess, constraints=constraints)

# Extract results
V1_opt, t1_opt, Qc_opt = solution.x

# Print the results
print(f"Optimal V1: {V1_opt}")
print(f"Optimal t1: {t1_opt} radians")
print(f"Optimal Qc: {Qc_opt}")