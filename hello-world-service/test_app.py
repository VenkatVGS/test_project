import pytest
from app import app

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

def test_hello_endpoint(client):
    """Test the hello endpoint returns 200 status code"""
    response = client.get('/')
    assert response.status_code == 200
    assert b"Hello" in response.data

def test_hello_endpoint_content(client):
    """Test the hello endpoint contains expected text"""
    response = client.get('/')
    assert response.status_code == 200
    # It should contain either the SSM message or fallback message
    assert b"Hello" in response.data
    assert b"EKS" in response.data
