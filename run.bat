venv\Scripts\python.exe setup.py build_ext --inplace
if %errorlevel% == 0 venv\Scripts\python.exe main.py
echo Exit code is %errorlevel%