from flask import Flask, request, jsonify, g, send_file, session
from flask_cors import CORS, cross_origin
from firebase_admin import credentials, db, initialize_app
from werkzeug.utils import secure_filename
import boto3
import json
import datetime
import logging
import os
import requests
# from werkzeug.security import generate_password_hash, check_password_hash
# from .map import connect_to_gmaps, get_map_img
# from functools import wraps

# Enable logging
logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    level=logging.INFO)

logger = logging.getLogger(__name__)

app = Flask(__name__)
cors = CORS(app)
app.config.from_json('config.json')
app.config['CORS_HEADERS'] = 'Content-Type'

# Initialize Firestore DB
cred = credentials.Certificate(app.config['FIREBASE'])
default_app = initialize_app(cred, options={
    'databaseURL': 'https://razer-fintech.firebaseio.com'
})
STORES = db.reference('stores')
ORDERS = db.reference('orders')

perx_hostname = 'https://api.perxtech.io/v4/'
perx_header_app = {'content-type': 'application/json', "Authorization": "Bearer " + os.environ['APP_LEVEL_TOKEN']}
perx_header_user = {'content-type': 'application/json', "Authorization": "Bearer " + os.environ['USER_LEVEL_TOKEN']}

@app.route('/store', methods=['POST'])
@cross_origin()
def create_store():
    try:
        store = json.loads(request.form['data'])
        if 'logo' not in request.files:
            store['logo'] = 'https://razerhack.s3-ap-southeast-1.amazonaws.com/logo_default.png'
        else:
            image = request.files['logo']
            client = boto3.client('s3',
                region_name='ap-southeast-1',                          
                aws_access_key_id=os.environ['AWS_ACCESS_KEY_ID'],
                aws_secret_access_key=os.environ['AWS_SECRET_ACCESS_KEY'])

            store['logo'] = put_image(image, client)

        fb_obj_store = STORES.push(store)
        return jsonify({'store_id': fb_obj_store.key}), 200, {'Content-Type': 'json; charset=utf-8'}
    except Exception as e:
        return f"An Error Occured: {e}", 500

@app.route('/store', methods=['GET'])
@cross_origin()
def get_all_stores():
    try:
        stores = STORES.get()
        for stores_id in stores.keys():
            stores[stores_id].pop('categories', None)
        return jsonify(stores), 200, {'Content-Type': 'json; charset=utf-8'}
    except Exception as e:
        return f"An Error Occured: {e}", 500

@app.route('/store/<store_id>', methods=['GET'])
@cross_origin()
def get_store(store_id):
    try:
        store = STORES.child(str(store_id)).get()
        if not store:
            return jsonify({"error": "store not found"}), 200
        return jsonify(store), 200, {'Content-Type': 'json; charset=utf-8'}
    except Exception as e:
        return f"An Error Occured: {e}", 500

@app.route('/store/<store_id>', methods=['PUT'])
@cross_origin()
def update_store(store_id):
    try:
        fb_obj_store = STORES.child(str(store_id))
        fb_obj_store.child('categories').delete()
        store = request.json
        categories = store.pop('categories', None)
        for cat in categories:
            items = cat.pop('items')
            fb_obj_categories = fb_obj_store.child('categories').push(cat)
            for item in items:
                fb_obj_items = fb_obj_categories.child('items').push(item)

        return jsonify({'store_id': fb_obj_store.key}), 200, {'Content-Type': 'json; charset=utf-8'}
    except Exception as e:
        return f"An Error Occured: {e}", 500

@app.route('/purchase/<store_id>', methods=['POST'])
@cross_origin()
def store_purchase(store_id):
    try:
        order = request.json
        fb_obj_store = STORES.child(str(store_id))
        fb_obj_order = fb_obj_store.child('orders').push(order)
        order['store_id'] = store_id
        fb_order = ORDERS.push(order)
        perx_create_transaction(fb_order.key, fb_order.get()['total'])
        return jsonify(fb_order.get()), 200, {'Content-Type': 'json; charset=utf-8'}
    except Exception as e:
        return f"An Error Occured: {e}", 500

@app.route('/orders', methods=['GET'])
@cross_origin()
def get_orders():
    try:
        fb_obj_orders = ORDERS.get()
        return jsonify(fb_obj_orders), 200, {'Content-Type': 'json; charset=utf-8'}
    except Exception as e:
        return f"An Error Occured: {e}", 500  

# Function to upload image to aws s3 and return the image url
def put_image(image, client):  
    image_file_name = secure_filename(image.filename)  
    bucket = 'razerhack'
    content_type = request.mimetype
    client.put_object(Body=image,
                  Bucket=bucket,
                  Key=image_file_name,
                  ContentType=content_type)
    boto3.resource('s3').ObjectAcl('razerhack', image_file_name).put(ACL='public-read')
    return 'https://razerhack.s3-ap-southeast-1.amazonaws.com/' + image_file_name

# Function to create new order
def perx_create_transaction(order_id, total):
    data = {"user_account_id": 1, "transaction_data": { "transaction_type": "purchase", "transaction_reference": order_id, "amount": total, "currency": "SGD", "properties": {}}}
    response = requests.post(perx_hostname + "pos/transactions", data=json.dumps(data), headers=perx_header_app)
    if response.status_code != 200:
        logger.info(response)
    logger.info(response.text)
    return response.text

@app.route('/vouchers', methods=['GET'])
@cross_origin()
def get_vouchers():
    try:
        response = requests.get(perx_hostname + "vouchers", headers=perx_header_user)
        if response.status_code != 200:
            logger.info(response)
        logger.info(response.text)
        return response.content, 200, {'Content-Type': 'json; charset=utf-8'}
    except Exception as e:
        return f"An Error Occured: {e}", 500  

