import unittest
import app
import os
import json

class TestStringMethods(unittest.TestCase):

    def test_auth_success(self):
        os.environ["USER"] = "test_user"
        os.environ["PASSWORD"] = "welcome01!"
        username = 'test_user'
        password = 'welcome01!'
        self.assertTrue(app.basic_auth(username, password))

    def test_auth_failure(self):
        os.environ["USER"] = "test_user"
        os.environ["PASSWORD"] = "welcome01!"
        username = 'test_user555'
        password = 'welcome01!'
        self.assertFalse(app.basic_auth(username, password))

    def test_get_city(self):
        self.assertEqual('Paris', app._get_city(48.864716, 2.349014))

    def test_get_consumption(self):
        points = json.loads("""
        [ 
            { 
                "timestamp": 1559137025, 
                "odometer": 7700, 
                "fuelLevel": 100, 
                "positionLat": 58.01046, 
                "positionLong": 56.25017
            },
            { 
                "timestamp": 1559137035, 
                "odometer": 7800, 
                "fuelLevel": 90, 
                "positionLat": 59.01046, 
                "positionLong": 56.25017
            }
        ]
        """)
        self.assertEqual(8, app._get_consumption(80, points))

    def test_get_get_stops(self):
        points = json.loads("""
        [ 
            { 
                "timestamp": 1559137025, 
                "odometer": 7700, 
                "fuelLevel": 100, 
                "positionLat": 58.01046, 
                "positionLong": 56.25017
            },
            { 
                "timestamp": 1559137035, 
                "odometer": 7800, 
                "fuelLevel": 90, 
                "positionLat": 59.01046, 
                "positionLong": 56.25017
            },
            { 
                "timestamp": 1559137045, 
                "odometer": 7800, 
                "fuelLevel": 89, 
                "positionLat": 59.01046, 
                "positionLong": 56.25017
            }
        ]
        """)
        res = json.loads('''
        [
            { 
                "startTimestamp": 1559137035, 
                "endTimestamp": 1559137045,
                "positionLat": 59.01046, 
                "positionLong": 56.25017
            }
        ]
        ''')
        self.assertEqual(res, app._get_stops(points,3))

    def test_get_get_refuel_stops(self):
        points = json.loads("""
        [ 
            { 
                "timestamp": 1559137025, 
                "odometer": 7700, 
                "fuelLevel": 50, 
                "positionLat": 58.01046, 
                "positionLong": 56.25017
            },
            { 
                "timestamp": 1559137027, 
                "odometer": 7700, 
                "fuelLevel": 100, 
                "positionLat": 58.01046, 
                "positionLong": 56.25017
            },
            { 
                "timestamp": 1559137035, 
                "odometer": 7800, 
                "fuelLevel": 90, 
                "positionLat": 59.01046, 
                "positionLong": 56.25017
            },
            { 
                "timestamp": 1559137045, 
                "odometer": 7800, 
                "fuelLevel": 89, 
                "positionLat": 59.01046, 
                "positionLong": 56.25017
            }
        ]
        """)
        res = json.loads('''
        [
            { 
                "startTimestamp": 1559137025, 
                "endTimestamp": 1559137027,
                "positionLat": 58.01046, 
                "positionLong": 56.25017
            }
        ]
        ''')
        self.assertEqual(res, app._get_stops(points, refuel=True))
    

if __name__ == '__main__':
    unittest.main()