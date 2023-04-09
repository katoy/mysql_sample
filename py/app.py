from flask import Flask, request, jsonify
from flask_mysqldb import MySQL
import json
import MySQLdb

app = Flask(__name__)

# MySQL の設定を行います
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'password'
app.config['MYSQL_DB'] = 'todo_app_db'

mysql = MySQL(app)

@app.route('/tasks', methods=['GET'])
def get_tasks():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM tasks')
    tasks = cursor.fetchall()
    return jsonify(tasks)


@app.route('/tasks', methods=['POST'])
def add_task():
    task = request.get_json()
    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO tasks (title, description, isCompleted) VALUES (%s, %s, %s)', (task['title'], task['description'], task['isCompleted']))
    mysql.connection.commit()
    return jsonify(task)

@app.route('/tasks/<int:task_id>', methods=['PUT'])
def update_task(task_id):
    task = request.get_json()
    cur = mysql.connection.cursor()
    cur.execute('UPDATE tasks SET title = %s, description = %s, isCompleted = %s WHERE id = %s', (task['title'], task['description'], task['isCompleted'], task_id))
    mysql.connection.commit()
    return jsonify(task)

@app.route('/tasks/<int:task_id>', methods=['DELETE'])
def delete_task(task_id):
    cur = mysql.connection.cursor()
    cur.execute('DELETE FROM tasks WHERE id = %s', (task_id,))
    mysql.connection.commit()
    return jsonify({'result': 'Task deleted'})

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0', port=5001)
