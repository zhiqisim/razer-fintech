from flask import Flask, request, jsonify, g, send_file, session
from firebase_admin import credentials, firestore, initialize_app
import json
# import jwt
import datetime
import logging
# from werkzeug.security import generate_password_hash, check_password_hash
# from .map import connect_to_gmaps, get_map_img
# from functools import wraps

# Enable logging
logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    level=logging.INFO)

logger = logging.getLogger(__name__)

app = Flask(__name__)
app.config.from_json('config.json')

# Initialize Firestore DB
cred = credentials.Certificate(app.config['FIREBASE'])
default_app = initialize_app(cred)
db = firestore.client()
users_ref = db.collection('users')


@app.route('/signup', methods=['POST'])
def signup():
    """
    Input: username, chat_id
    Output: user_id
    """
    data = request.get_json()
    username = data["username"]
    chat_id = data["chat_id"]
    # add to firebase
    try:
        users_ref.document(str(chat_id)).set(request.json)
        status_code = 201
        response = {
            "message": "success",
        }
        return json.dumps(response), status_code, {'Content-Type': 'json; charset=utf-8'}
    except Exception as e:
        return f"An Error Occured: {e}", 500

@app.route('/write-diary', methods=['POST'])
def write_data():
    """
    Input: **
    Output: **
    """
    data = request.get_json()
    chat_id = data["chat_id"]
    title = data["title"]
    diary_post = data["diary_post"]
    today = datetime.date.today()
    dateToday = today.strftime("%Y-%m-%d")
    response = {
        "title": title,
        "diary_post": diary_post,
        "date": today.strftime("%d/%m/%Y")
    }
    logger.info(response)

    # add to firebase
    try:
        users_ref.document(str(chat_id)).collection("diary").add(response)
        status_code = 201
        response = {
            "message": "success",
        }
        return json.dumps(response), status_code, {'Content-Type': 'json; charset=utf-8'}
    except Exception as e:
        return f"An Error Occured: {e}", 500

    

@app.route('/read-diary', methods=['GET'])
def read_data():
    """
    Params: **
    Output: **
    """
    chat_id = request.args.get('id')
    # retrieve from firebase
    try:
        # Check if ID was passed to URL query
        # if chat_id:
        #     diaries = users_ref.document(chat_id).get()
        #     return jsonify(diaries.to_dict()), 200
        # else:
        all_diaries = [doc.to_dict() for doc in users_ref.document(str(chat_id)).collection("diary").stream()]
        return jsonify(all_diaries), 200, {'Content-Type': 'json; charset=utf-8'}
    except Exception as e:
        return f"An Error Occured: {e}", 500
