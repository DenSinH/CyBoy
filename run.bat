venv\Scripts\python.exe setup.py build_ext --inplace --force
venv\Scripts\python.exe main.py
echo Exit code is %errorlevel%