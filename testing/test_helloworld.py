import pytest
from app import app


@pytest.fixture
def client():
    return app.test_client()

def test_helloworld(client):
    resp = client.get('/helloworld')
    assert resp.status_code == 200
    assert isinstance(resp.json, dict)
    assert resp.json.get('message', 'Hello Stranger')

def test_helloworld_name(client):
    resp = client.get('/helloworld?name=HosseinKarjoo')
    assert resp.status_code == 200
    assert isinstance(resp.json, dict)
    assert resp.json.get('message', 'Hello Hossein Karjoo')

