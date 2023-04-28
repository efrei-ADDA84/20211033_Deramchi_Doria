import os
import requests
from fastapi import FastAPI, Request

app = FastAPI()

@app.get("/")
async def get_weather(request: Request):
    api_key = os.getenv("API_KEY", "")
    lat = request.query_params.get('lat')
    lon = request.query_params.get('lon')
    url = f"https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={api_key}"
    weather = requests.get(url).json()
    info_globale = weather["weather"][0]["description"]
    ville = weather["name"]
    temperature = weather["main"]["temp"] - 273.15
    return {"ville": ville, "info_globale": info_globale, "temperature": temperature}


"""
import os
import requests

#def get_weather(latitude, longitude):
api_key = os.getenv('API_KEY','Key not found')
latitude = os.getenv('LAT','31.2504')
longitude = os.getenv('LONG','-99.2506')
url = f'https://api.openweathermap.org/data/2.5/weather?lat={latitude}&lon={longitude}&appid={api_key}'
response = requests.get(url)
if response.status_code == 200:
    data = response.json()
    temperature = data['main']['temp'] - 272.15
    description = data['weather'][0]['description']
    print(f'Temperature: {temperature}°C\nDescription: {description}') 
else:
    print('Unable to retrieve weather data')   

#latitude = '31.2504'
#longitude = '-99.2506'
#print(get_weather(latitude, longitude))
"""

