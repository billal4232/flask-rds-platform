from flask import Flask, request, jsonify
import psycopg2
import os
import secrets

import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s %(levelname)s %(message)s'
)
logger = logging.getLogger(__name__)

app = Flask(__name__)

def get_db_connection():
    try:
        conn = psycopg2.connect(
            host=os.getenv('DB_HOST'),
            port=os.getenv('DB_PORT'),
            dbname=os.getenv('DB_NAME'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASSWORD')
        )
        return conn
    
    except Exception as e:
        logger.error(f"Database connection failed: {e}")
        raise
    

def create_table():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id SERIAL PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                email VARCHAR(100) NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        conn.commit()
        cur.close()
        conn.close()
    except Exception as e:
        logger.error(f"Table creation failed: {e}")
        raise

def check_api_key():
    api_key = request.headers.get('X-API-Key')
    expected_key = os.getenv('API_KEY')
    if not api_key or not secrets.compare_digest(api_key, expected_key):
        return jsonify({'error': 'Unauthorized'}), 401
    return None
    

@app.route('/')
def home():
    return jsonify({'message': 'Checking if it works without pressing action button on github', 'status': 'running'}), 200

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'}), 200

@app.route('/users', methods=['GET'])
def fetch_users():
    try:
        error = check_api_key()
        if error:
           return error
        conn = get_db_connection()
        cur = conn.cursor() 
        cur.execute('SELECT * FROM users')
        users = cur.fetchall()
        cur.close()
        conn.close()
        return jsonify(users), 200
    
    except Exception as e:
        logger.error(f"Fetching user failed: {e}")
        raise

@app.route('/users', methods=['POST'])
def create_user():
    try:
        error = check_api_key()
        if error:
           return error
        data = request.get_json()
        name = data['name']
        email = data['email']
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(
            'INSERT INTO users (name, email) VALUES (%s, %s)',
            (name, email)
        )
        conn.commit()
        cur.close()
        conn.close()
        logger.info(f"User created: {name} {email}")
        return jsonify({'message': 'User created'}), 201
    except Exception as e:
        logger.error(f"User creation failed: {e}")
        raise

create_table()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

