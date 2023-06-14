"""
@author: jamesmcneill
Overview: code used to review if a package exists and to install if missing from library
Example code: will install the library name(s) contained within the requirements list
    requirements = ["yfinance"]
    for requirement in requirements:
        installPackage(requirement)
"""

# Import libraries
import sys
import subprocess

# Function to review and install package if missing
def installPackage(package):
    p = subprocess.run([sys.executable, "-m", "pip", "install", "-U", package], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    print(p.stdout.decode())
