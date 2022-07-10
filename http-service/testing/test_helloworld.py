import pytest
import os
from app import app


@pytest.fixture
def client():
    return app.test_client()

def test_helloworld(client):
    resp = client.get('/helloworld')
    assert resp.status_code == 200
    assert b"Hello Stranger" in resp.data

def test_helloworld_name(client):
    resp = client.get('/helloworld?name=HosseinKarjoo')
    assert resp.status_code == 200    
    assert b"Hello Hossein Karjoo" in resp.data

def test_versionz(client):
    resp = client.get('/versionz')
    git_hash = bytes(os.getenv('GITHASH'))
    project_name = bytes(os.getenv('GITREPO'))
    assert resp.status_code == 200
#    assert isinstance(resp.json, dict)
    assert git_hash + project_name in resp.data
