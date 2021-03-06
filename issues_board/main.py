""" Falsk main 

"""

from flask import Flask
app = Flask(__name__)

@app.route('/')
def index():
    return 'Hello World!'

@app.route('/bugs/dashboard')
def bugs_dashboard():
    return 'Hello World!'

@app.route('/bugs/status/<int:bugId>')
def bugs_status():
    return 'Hello World!'

@app.route('/bug_sync_github')
def bug_sync_github():
    return 'Hello World!'

@app.route('/bug_sync_report/<reportType>')
def bug_sync_report():
    return 'Hello World!'

if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0')