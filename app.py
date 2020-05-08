#!/usr/bin/env python3
import connexion
import datetime
import logging
import os
import json

import googlemaps

from jsonschema import validate

gmaps = googlemaps.Client(key=os.getenv('GEO_KEY'))


def basic_auth(username, password, required_scopes=None):
    if username == os.getenv('USER') and password == os.getenv('PASSWORD'):
        return {'sub': 'admin'}
    return None

def _get_city(lat, long):
    reverse_json = gmaps.reverse_geocode((lat, long))
    return [x['long_name'] for x in reverse_json[0]['address_components'] if 'locality' in x['types']][0]

def _get_consumption(gasTankSize, points):
    fuel = 0
    distance = points[-1]['odometer'] - points[0]['odometer']

    # get fuel spent in liters
    for i, item in enumerate(points):
        if i + 1 < len(points):
            f_start = points[i]['fuelLevel']
            f_end = points[i+1]['fuelLevel']
            if f_start > f_end:
                fuel += (f_start - f_end) * gasTankSize / 100

    # get liters/100 km
    consumption = fuel * 100 / distance
    
    return consumption


def _get_stops(points, breakThreshold=1800, refuel=False):
    breaks = []

    for i, item in enumerate(points):
        if i + 1 < len(points):
            date1 = points[i]['timestamp']
            date2 = points[i+1]['timestamp']
            
            if points[i+1]['positionLat'] == points[i]['positionLat'] and points[i+1]['positionLong'] == points[i]['positionLong']:
                if (refuel == False and date2 - date1 > breakThreshold) or points[i+1]['fuelLevel'] > points[i]['fuelLevel']:
                    b = {}
                    b['startTimestamp'] = date1
                    b['endTimestamp'] = date2
                    b['positionLat'] = points[i+1]['positionLat']
                    b ['positionLong'] = points[i+1]['positionLong']
                    breaks.append(b)

    return breaks

def analyze(body):

    try:
        schema = ''
        with open('schema.json') as f:
            schema = json.loads(f.read())

        # validate input
        validate(instance=body, schema=schema)

        # order points by timestamp value
        points = body['data']
        points.sort(key=lambda k: k['timestamp'], reverse=False)

        # get departure city name
        departure = _get_city(points[0]['positionLat'], points[0]['positionLong'])

        # get destination city name
        destination = _get_city(points[-1]['positionLat'], points[-1]['positionLong'])

        # get fuel consumption (liters / 100 km)
        consumption = _get_consumption(body['gasTankSize'], points)

        # get breaks
        breaks = _get_stops(points, body['breakThreshold'])

        # get refuel stops
        refuelStops = _get_stops(points,body['breakThreshold'],refuel=True)

        res = {}

        res['vin'] = body['vin']
        res['departure'] = departure
        res['destination'] = destination
        res['refuelStops'] = refuelStops
        res['consumption'] = consumption
        res['breaks'] = breaks

    except Exception:
        res = {}
        res['detail'] = 'Invalid input'
        res['status'] = 405
        return res, 405

    return res
    
    
logging.basicConfig(level=logging.INFO)
app = connexion.App(__name__)
app.add_api('swagger.yaml')
application = app.app

if __name__ == '__main__':
    # run our standalone gevent server
    app.run(port=8080, server='gevent')

