# 🔒 Password Validator  

A Bash script to enforce strong password policies.  

## Features  
- **Validates**:  
  - Minimum length (8+ characters).  
  - At least 1 digit (`0-9`) and 1 special char (`@#$%&*+-=`).  
  - Blocks dictionary words/4+ char sequences.  
- **CLI Options**:  
  - `-t [password]`: Test a password.  
  - `-h`: Show help.  
  - `-v`: Show version.  

## Usage  
```bash
./password.sh -t "YourPassword123@"
