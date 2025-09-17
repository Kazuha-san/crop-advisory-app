from fastapi import FastAPI, Query, HTTPException
import requests

app = FastAPI(title="Smart Farming Backend")

# ----------------- Weather Endpoint -----------------
@app.get("/weather")
def weather(
    lat: float = Query(..., description="Latitude"),
    lon: float = Query(..., description="Longitude")
):
    API_KEY = "d30b4f6278231f6779332f25639a03d5"
    url = f"https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API_KEY}&units=metric"

    try:
        res = requests.get(url, timeout=10)
        res.raise_for_status()
        data = res.json()
        return {
            "temp": data["main"]["temp"],
            "feels_like": data["main"]["feels_like"],
            "temp_min": data["main"]["temp_min"],
            "temp_max": data["main"]["temp_max"],
            "humidity": data["main"]["humidity"],
            "pressure": data["main"]["pressure"],
            "wind_speed": data["wind"]["speed"],
            "description": data["weather"][0]["description"],
            "city": data.get("name", ""),
            "country": data.get("sys", {}).get("country", "")
        }
    except requests.RequestException as e:
        raise HTTPException(status_code=500, detail=f"Weather API request failed: {e}")
    except KeyError:
        raise HTTPException(status_code=500, detail="Unexpected response format from weather API")

# ----------------- GPS Endpoint -----------------
@app.get("/gps")
def get_location():
    return {"message": "Send lat/lon from frontend; backend does not generate GPS itself"}

# ----------------- Health Check -----------------
@app.get("/health")
def health_check():
    return {"status": "ok", "message": "Smart Farming backend is running!"}
