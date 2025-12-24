from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import fastf1
import pandas as pd
import os

app = FastAPI(title="F1 Pitwall Engine")

# 1. Enable CORS (So Flutter can talk to Python)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 2. Setup Cache (Crucial for speed)
cache_dir = os.path.join(os.getcwd(), 'cache')
if not os.path.exists(cache_dir):
    os.makedirs(cache_dir)
fastf1.Cache.enable_cache(cache_dir)

@app.get("/")
def home():
    return {"status": "Pitwall Engine Ready", "version": "2.0"}

# --- ENDPOINT 1: Get Driver List for the Leaderboard ---
# We will use hardcoded "2023 Bahrain Qualifying" for now to test the UI
@app.get("/api/leaderboard")
async def get_leaderboard():
    try:
        # Load the session
        session = fastf1.get_session(2023, 'Bahrain', 'Q')
        session.load(telemetry=False, laps=False, weather=False) # Fast load
        
        # Get the results (Classification)
        results = session.results
        
        drivers = []
        for driver_code in results['Abbreviation']:
            d_info = results.loc[results['Abbreviation'] == driver_code].iloc[0]
            
            # Extract key data
            drivers.append({
                "position": int(d_info['Position']),
                "symbol": driver_code, # e.g. VER
                "name": d_info['FullName'],
                "team": d_info['TeamName'],
                "color": d_info['TeamColor'], # Hex color
                "time": str(d_info['Q3']) if not pd.isnull(d_info['Q3']) else "No Time"
            })
            
        return drivers
    except Exception as e:
        print(f"Error: {e}")
        raise HTTPException(status_code=500, detail=str(e))
    

@app.get("/api/telemetry/{driver_id}")
async def get_telemetry(driver_id: str):
    try:
        # 1. Load the same session (Bahrain 2023 Q)
        session = fastf1.get_session(2023, 'Bahrain', 'Q')
        session.load(telemetry=True, laps=True, weather=False)
        
        # 2. Pick the driver's fastest lap
        # 'pick_driver' finds the car, 'pick_fastest' gets their best lap
        lap = session.laps.pick_driver(driver_id).pick_fastest()
        
        # 3. Get the telemetry (Speed, RPM, Throttle, Brake)
        tel = lap.get_telemetry()
        
        # 4. Prepare data for Flutter (List of X/Y points)
        # We simplify it by taking every 5th point to reduce lag
        data = []
        for i in tel.index[::5]: 
            data.append({
                "dist": float(tel['Distance'][i]),
                "speed": float(tel['Speed'][i]),
                "throttle": float(tel['Throttle'][i]),
                "brake": float(tel['Brake'][i])
            })
            
        return {
            "driver": driver_id,
            "lap_time": str(lap['LapTime']),
            "telemetry": data
        }

    except Exception as e:
        print(f"Error fetching telemetry: {e}")
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)