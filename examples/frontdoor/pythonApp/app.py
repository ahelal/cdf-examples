from flask import Flask, request
app = Flask(__name__)

@app.route('/', defaults={'path': ''}, methods=['POST', 'GET','DELETE', 'HEAD', 'PUT'])
@app.route('/<path:path>', methods=['POST', 'GET','DELETE', 'HEAD', 'PUT'])
def catch_all(path):
    args = request.args.to_dict()
    method = request.method
    msg = "Thank you for your request."
    print(request.headers)
    return {"Message": msg, "properties": {"path": path, "method":method, "args": args, "headers": dict(request.headers)}}

if __name__ == '__main__':
    app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True
    app.run()
